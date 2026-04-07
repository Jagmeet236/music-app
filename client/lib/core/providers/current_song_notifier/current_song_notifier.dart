import 'dart:async';
import 'package:client/core/providers/current_song_notifier/current_song_state.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
/// Notifier that manages the currently playing song, audio player, and queue.
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? _audioPlayer;
  StreamSubscription<PlayerState>? _playerStateSub;

  /// A resolver callback that returns the LIVE playlist at the moment of calling.
  /// This is the key mechanism for the Recently Played list — instead of a frozen
  /// snapshot, we hold a reference to a function that always returns the current list.
  List<SongModel> Function()? _playlistResolver;

  @override
  CurrentSongState build() {
    // Auto-dispose: clean up audio resources when the provider is removed.
    ref.onDispose(() async {
      await _cleanUp();
    });
    return const CurrentSongState();
  }

  /// Provides access to the current [AudioPlayer] instance, if any.
  AudioPlayer? get audioPlayer => _audioPlayer;

  /// Plays a song from a playlist (either the API list or Recently Played).
  ///
  /// [playlist] is a **frozen snapshot** of the list captured at the moment
  /// the user taps a card. We freeze it deliberately so that the LRU
  /// reordering of the Recently Played list cannot affect navigation order.
  /// [index] is the tapped position within that frozen snapshot.
  ///
  /// Navigation (next/prev) always searches the frozen snapshot by song [id],
  /// which is stable even if the same object moves position in the live UI list.
  Future<void> updateSong(
    SongModel song, {
    List<SongModel>? playlist,
    int? index,
  }) async {
    // Store a resolver that always returns the same frozen snapshot.
    if (playlist != null) {
      // Capture playlist in a local variable so the closure holds a frozen copy.
      final frozenPlaylist = playlist;
      _playlistResolver = () => frozenPlaylist;
    }

    // Delegate actual audio loading to the internal method.
    await _loadAndPlay(song, index: index);
  }

  /// Internal method: handles all audio player setup, teardown, and state updates.
  Future<void> _loadAndPlay(SongModel song, {int? index}) async {
    // Skip if the exact same URL is already loaded and playing.
    if (state.song?.songUrl == song.songUrl) {
      if (_audioPlayer != null && !_audioPlayer!.playing) {
        await _audioPlayer!.play();
      }
      return;
    }

    // Cancel old subscription and dispose the previous player before creating a new one.
    await _cleanUp();

    _audioPlayer = AudioPlayer();

    // Update UI state immediately so artwork/title appear before the network loads.
    state = state.copyWith(
      song: song,
      isPlaying: false,
      currentIndex: index ?? state.currentIndex,
    );

    try {
      await _audioPlayer!.setAudioSource(
        AudioSource.uri(Uri.parse(song.songUrl!)),
      );

      // Subscribe to player state to track playing/paused and song completion.
      _playerStateSub = _audioPlayer!.playerStateStream.listen(
        (playerState) {
          final isActuallyPlaying =
              playerState.playing &&
              playerState.processingState == ProcessingState.ready;

          // Sync Riverpod state with the real player state.
          state = state.copyWith(isPlaying: isActuallyPlaying);

          // Automatically advance to the next song when the current one ends.
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
      // just_audio-specific exception — contains platform error code.
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

  /// Toggles play/pause for the current song.
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

  /// Seeks to a specific [position] in the current song.
  void seekTo(Duration position) {
    _audioPlayer?.seek(position);
  }

  /// Advances to the next song in the queue with circular wrap-around.
  ///
  /// Steps:
  /// 1. Call the resolver to get the **frozen** snapshot captured at tap time.
  /// 2. Search by song [id] (not by stored index) — this is resilient to any
  ///    live list reordering that may have happened since the snapshot was taken.
  /// 3. Compute [nextIndex] with circular wrap: last item wraps back to 0.
  Future<void> playNext() async {
    // Retrieve the frozen playlist; stop if nothing is loaded yet.
    final playlist = _playlistResolver?.call();
    if (playlist == null || playlist.isEmpty || state.song == null) return;

    // Locate current song by ID inside the frozen snapshot — position-safe.
    final currentId = state.song!.id;
    final frozenIndex = playlist.indexWhere((s) => s.id == currentId);

    // Circular wrap: if at the last position (or song not found), jump to 0.
    final nextIndex = (frozenIndex == -1 || frozenIndex >= playlist.length - 1)
        ? 0
        : frozenIndex + 1;

    final nextSong = playlist[nextIndex];

    // Load the next song; the resolver closure (frozen list) is preserved.
    await _loadAndPlay(nextSong, index: nextIndex);
  }

  /// Goes back to the previous song in the queue with circular wrap-around.
  ///
  /// Steps:
  /// 1. Call the resolver to get the **frozen** snapshot captured at tap time.
  /// 2. Search by song [id] (not by stored index) — resilient to reordering.
  /// 3. Compute [prevIndex] with circular wrap: index 0 wraps to the last item.
  Future<void> playPrevious() async {
    // Retrieve the frozen playlist; stop if nothing is loaded yet.
    final playlist = _playlistResolver?.call();
    if (playlist == null || playlist.isEmpty || state.song == null) return;

    // Locate current song by ID inside the frozen snapshot — position-safe.
    final currentId = state.song!.id;
    final frozenIndex = playlist.indexWhere((s) => s.id == currentId);

    // Circular wrap: if at the first position (or song not found), jump to last.
    final prevIndex = (frozenIndex <= 0)
        ? playlist.length - 1
        : frozenIndex - 1;

    final prevSong = playlist[prevIndex];

    // Load the previous song; the resolver closure (frozen list) is preserved.
    await _loadAndPlay(prevSong, index: prevIndex);
  }

  /// Stops playback and resets state entirely (e.g., on logout).
  Future<void> stopAndClear() async {
    _playlistResolver = null;
    await _cleanUp();
    state = const CurrentSongState();
  }

  /// Called automatically when the audio player signals `ProcessingState.completed`.
  /// Instead of stopping, we seamlessly advance to the next track.
  void _handleSongCompletion() {
    // Delegate to playNext which handles circular wrap-around automatically.
    playNext();
  }

  /// Cancels the player state subscription and disposes the audio player safely.
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

