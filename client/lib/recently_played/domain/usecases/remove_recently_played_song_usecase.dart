import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/recently_played/domain/repositories/recently_played_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for removing a specific recently played song.
class RemoveRecentlyPlayedSongUseCase
    implements UseCaseWithParams<void, RemoveRecentlyPlayedSongParams> {
  /// Creates a [RemoveRecentlyPlayedSongUseCase].
  const RemoveRecentlyPlayedSongUseCase(this._repository);

  final RecentlyPlayedRepository _repository;

  @override
  ResultFuture<void> call(RemoveRecentlyPlayedSongParams params) async {
    try {
      await _repository.removeRecentlyPlayedSong(params.userId, params.songId);
      return const Right(null);
     }on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}

/// Parameters for [RemoveRecentlyPlayedSongUseCase].
class RemoveRecentlyPlayedSongParams {
  /// Creates [RemoveRecentlyPlayedSongParams].
  const RemoveRecentlyPlayedSongParams({
    required this.userId,
    required this.songId,
  });

  /// The user ID whose recently played song is removed.
  final String userId;

  /// The song ID to remove.
  final String songId;
}
