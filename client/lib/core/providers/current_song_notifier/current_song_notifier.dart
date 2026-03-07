import 'dart:async';
import 'package:client/core/providers/current_song_notifier/current_song_state.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
/// Manages the audio playback and current song state in the app.
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? _audioPlayer;

  @override
  CurrentSongState build() {
    return const CurrentSongState();
  }

  /// ✅ Public getter so the UI can access positionStream and duration
  AudioPlayer? get audioPlayer => _audioPlayer;

  /// Updates the currently playing song
  Future<void> updateSong(SongModel song) async {
    if (state.song?.songUrl == song.songUrl) return;

    await _disposePlayer();

    _audioPlayer = AudioPlayer();

    // Update song immediately so UI reflects change
    state = state.copyWith(song: song, isPlaying: false);

    try {
      final audioSource = AudioSource.uri(Uri.parse(song.songUrl!));
      await _audioPlayer!.setAudioSource(audioSource);

      /// ✅ Listen to player state and update isPlaying reactively
      _audioPlayer!.playerStateStream.listen((playerState) {
        final isActuallyPlaying =
            playerState.playing &&
            playerState.processingState == ProcessingState.ready;

        state = state.copyWith(isPlaying: isActuallyPlaying);

        if (playerState.processingState == ProcessingState.completed) {
          _audioPlayer!.seek(Duration.zero);
          _audioPlayer!.pause();
          state = state.copyWith(isPlaying: false);
        }
      });

      await _audioPlayer!.play();
    } on Exception catch (e, stack) {
      debugPrint('❌ Error loading/playing audio: $e');
      if (kDebugMode) print(stack);
      state = state.copyWith(isPlaying: false);
    }
  }

  /// Toggles play/pause for the current song
  Future<void> playPause() async {
    if (_audioPlayer == null) return;

    try {
      if (_audioPlayer!.playing) {
        await _audioPlayer!.pause();
      } else {
        await _audioPlayer!.play();
      }
      // ❌ Don't set state here — let the listener handle it
    } on Exception catch (e) {
      debugPrint('❌ Error toggling playback: $e');
    }
  }

  /// Seeks to a specific position in the song
  void seekTo(Duration position) {
    _audioPlayer?.seek(position);
  }

  /// Dispose player and subscription
  Future<void> _disposePlayer() async {
    try {
      await _audioPlayer?.dispose();
    } on Exception catch (e) {
      debugPrint('❌ Error disposing AudioPlayer: $e');
    } finally {
      _audioPlayer = null;
    }
  }
}
