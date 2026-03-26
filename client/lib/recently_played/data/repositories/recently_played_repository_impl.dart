import 'package:client/home/data/models/song_model.dart';
import 'package:client/recently_played/data/datasources/recently_played_local_data_source.dart';
import 'package:client/recently_played/domain/repositories/recently_played_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recently_played_repository_impl.g.dart';

/// Provides an instance of [RecentlyPlayedRepository].
@Riverpod(keepAlive: true)
RecentlyPlayedRepository recentlyPlayedRepository(
  RecentlyPlayedRepositoryRef ref,
) {
  final localDataSource = ref.watch(recentlyPlayedLocalDataSourceProvider);
  return RecentlyPlayedRepositoryImpl(localDataSource);
}

/// Concrete implementation of [RecentlyPlayedRepository]
///  using a local data source.
class RecentlyPlayedRepositoryImpl implements RecentlyPlayedRepository {
  /// creating the repository
  RecentlyPlayedRepositoryImpl(this.localDataSource);

  /// getting the local data source
  final RecentlyPlayedLocalDataSource localDataSource;

  @override
  Future<List<SongModel>> getRecentlyPlayedSongs(String userId) {
    return localDataSource.getRecentlyPlayedSongs(userId);
  }

  @override
  Future<void> saveRecentlyPlayedSongs(String userId, List<SongModel> songs) {
    return localDataSource.saveRecentlyPlayedSongs(userId, songs);
  }

  @override
  Future<void> clearRecentlyPlayedSongs(String userId) {
    return localDataSource.clearRecentlyPlayedSongs(userId);
  }

  @override
  Future<void> removeRecentlyPlayedSong(String userId, String songId) {
    return localDataSource.removeRecentlyPlayedSong(userId, songId);
  }
}
