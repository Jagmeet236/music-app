import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/recently_played/data/repositories/recently_played_repository_impl.dart';
import 'package:client/recently_played/domain/usecases/get_recently_played_songs_usecase.dart';
import 'package:client/recently_played/domain/usecases/remove_recently_played_song_usecase.dart';
import 'package:client/recently_played/domain/usecases/save_recently_played_songs_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recently_played_viewmodel.g.dart';

/// ViewModel responsible for managing the state of
///  recently played songs.
/// It listens to the current song and current user
/// to update the list.
@riverpod
class RecentlyPlayedViewModel extends _$RecentlyPlayedViewModel {
  /// Initializes the view model by loading the recently played songs.
  @override
  FutureOr<List<SongModel>> build() async {
    // Listen to current song changes to automatically add to recently played
    ref
      ..listen(currentSongNotifierProvider, (previous, next) {
        if (next.song != null &&
            previous?.song?.songUrl != next.song?.songUrl) {
          addRecentlyPlayedSong(next.song!);
        }
      })
      // Listen to user logout to clear the current user's list from state
      ..listen(currentUserNotifierProvider, (previous, next) {
        if (next == null) {
          state = const AsyncData([]);
        } else if (previous == null && next != null) {
          // If a new user logs in, reload the data
          ref.invalidateSelf();
        }
      });

    return _loadSongs();
  }

  Future<List<SongModel>> _loadSongs() async {
    final user = ref.read(currentUserNotifierProvider);
    if (user?.id == null) return [];

    final repository = ref.read(recentlyPlayedRepositoryProvider);
    final getSongsUseCase = GetRecentlyPlayedSongsUseCase(repository);

    final result = await getSongsUseCase(
      GetRecentlyPlayedSongsParams(userId: user!.id!),
    );
    return result.fold((failure) => [], (songs) => songs);
  }

  /// Adds a new [song] to the recently played list.
  /// Moves it to index 0 if it already exists, using an LRU policy.
  Future<void> addRecentlyPlayedSong(SongModel song) async {
    final user = ref.read(currentUserNotifierProvider);
    if (user?.id == null) return;

    final repository = ref.read(recentlyPlayedRepositoryProvider);

    // Get current list directly from state if available, or load it
    final currentSongs = state.valueOrNull ?? await _loadSongs();

    // LRU logic: remove if exists, insert at 0, limit to 30
    final updatedList =
        List<SongModel>.from(currentSongs)
          ..removeWhere((s) => s.id == song.id) // Remove existing
          ..insert(0, song); // Insert at top
    if (updatedList.length > 30) {
      updatedList.removeLast(); // Trim to max 30 items
    }

    // Optimistic state update
    state = AsyncData(updatedList);

    // Persist in local storage
    final saveSongsUseCase = SaveRecentlyPlayedSongsUseCase(repository);
    await saveSongsUseCase(
      SaveRecentlyPlayedSongsParams(userId: user!.id!, songs: updatedList),
    );
  }

  /// Removes a song from the recently played list by its [songId].
  Future<void> removeRecentlyPlayedSong(String songId) async {
    final user = ref.read(currentUserNotifierProvider);
    if (user?.id == null) return;

    final repository = ref.read(recentlyPlayedRepositoryProvider);

    final currentSongs = state.valueOrNull ?? [];
    if (currentSongs.isEmpty) return;

    final updatedList = List<SongModel>.from(currentSongs)
      // Right shift deletion O(n)
      ..removeWhere((s) => s.id == songId);

    // Update state to trigger animation immediately
    state = AsyncData(updatedList);

    // Persist to local storage
    final removeSongUseCase = RemoveRecentlyPlayedSongUseCase(repository);
    await removeSongUseCase(
      RemoveRecentlyPlayedSongParams(userId: user!.id!, songId: songId),
    );
  }
}
