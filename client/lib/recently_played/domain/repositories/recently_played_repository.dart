import 'package:client/home/data/models/song_model.dart';

/// Repository interface for managing recently played songs.
abstract class RecentlyPlayedRepository {
  /// Retrieves the list of recently played songs for the given [userId].
  Future<List<SongModel>> getRecentlyPlayedSongs(String userId);

  /// Saves the list of recently played [songs] for the given [userId].
  Future<void> saveRecentlyPlayedSongs(String userId, List<SongModel> songs);

  /// Clears the entire list of recently played songs for the given [userId].
  Future<void> clearRecentlyPlayedSongs(String userId);

  /// Removes a specific song by [songId] for the given [userId].
  Future<void> removeRecentlyPlayedSong(String userId, String songId);
}
