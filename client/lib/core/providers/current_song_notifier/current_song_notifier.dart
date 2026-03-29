import 'dart:async';
import 'package:client/core/providers/current_song_notifier/current_song_state.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
/// Notifier that manages the currently playing song and its audio player.
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? _audioPlayer;
  StreamSubscription<PlayerState>? _playerStateSub; // ✅ Track subscription

  @override
  CurrentSongState build() {
    // ✅ Auto-dispose when provider is removed
    ref.onDispose(() async {
      await _cleanUp();
    });
    return const CurrentSongState();
  }

  /// Provides access to the current [AudioPlayer] instance, if any.
  AudioPlayer? get audioPlayer => _audioPlayer;

  /// Updates the currently playing song, handling all audio player
  ///  setup and state management.
  Future<void> updateSong(SongModel song) async {
    // Skip if same song is already loaded
    if (state.song?.songUrl == song.songUrl) {
      // Just ensure it's playing if paused
      if (_audioPlayer != null && !_audioPlayer!.playing) {
        await _audioPlayer!.play();
      }
      return;
    }

    await _cleanUp(); // ✅ Cancel sub + dispose player before creating new one

    _audioPlayer = AudioPlayer();

    // Show song in UI immediately before network load
    state = state.copyWith(song: song, isPlaying: false);

    try {
      await _audioPlayer!.setAudioSource(
        AudioSource.uri(Uri.parse(song.songUrl!)),
      );

      // ✅ Store subscription so we can cancel it later
      _playerStateSub = _audioPlayer!.playerStateStream.listen(
        (playerState) {
          final isActuallyPlaying =
              playerState.playing &&
              playerState.processingState == ProcessingState.ready;

          state = state.copyWith(isPlaying: isActuallyPlaying);

          if (playerState.processingState == ProcessingState.completed) {
            _handleSongCompletion();
          }
        },
        onError: (Object e, StackTrace stack) {
          debugPrint('❌ PlayerState stream error: $e');
          state = state.copyWith(isPlaying: false);
        },
      );

      await _audioPlayer!.play();
    } on PlayerException catch (e) {
      // just_audio specific exception — contains error code
      debugPrint('❌ PlayerException [code: ${e.code}]: ${e.message}');
      state = state.copyWith(isPlaying: false);
    } on PlayerInterruptedException catch (e) {
      debugPrint('❌ Playback interrupted: ${e.message}');
      state = state.copyWith(isPlaying: false);
    } on Exception catch (e, stack) {
      debugPrint('❌ Error loading/playing audio: $e');
      if (kDebugMode) print(stack);
      state = state.copyWith(isPlaying: false);
    }
  }

  /// Toggles play/pause state of the current song.
  Future<void> playPause() async {
    if (_audioPlayer == null) return;

    try {
      if (_audioPlayer!.playing) {
        await _audioPlayer!.pause();
      } else {
        await _audioPlayer!.play();
      }
    } on Exception catch (e) {
      debugPrint('❌ Error toggling playback: $e');
    }
  }

  /// Seeks to a specific position in the current song.
  void seekTo(Duration position) {
    _audioPlayer?.seek(position);
  }

  ///
  Future<void> stopAndClear() async {
    await _cleanUp();
    state = const CurrentSongState();
  }

  void _handleSongCompletion() {
    _audioPlayer?.seek(Duration.zero);
    _audioPlayer?.pause();
    state = state.copyWith(isPlaying: false);
  }

  /// ✅ Cancel stream subscription AND dispose player safely
  Future<void> _cleanUp() async {
    await _playerStateSub?.cancel();
    _playerStateSub = null;

    try {
      await _audioPlayer?.stop();
      await _audioPlayer?.dispose();
    } on Exception catch (e) {
      debugPrint('❌ Error during player cleanup: $e');
    } finally {
      _audioPlayer = null;
    }
  }
}
