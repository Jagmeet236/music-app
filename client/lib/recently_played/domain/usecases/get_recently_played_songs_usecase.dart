import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/recently_played/domain/repositories/recently_played_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for retrieving the recently played songs.
class GetRecentlyPlayedSongsUseCase
    implements
        UseCaseWithParams<List<SongModel>, GetRecentlyPlayedSongsParams> {
  /// Creates a [GetRecentlyPlayedSongsUseCase].
  const GetRecentlyPlayedSongsUseCase(this._repository);

  final RecentlyPlayedRepository _repository;

  @override
  ResultFuture<List<SongModel>> call(
    GetRecentlyPlayedSongsParams params,
  ) async {
    try {
      final songs = await _repository.getRecentlyPlayedSongs(params.userId);
      return Right(songs);
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}

/// Parameters for [GetRecentlyPlayedSongsUseCase].
class GetRecentlyPlayedSongsParams {
  /// Creates [GetRecentlyPlayedSongsParams].
  const GetRecentlyPlayedSongsParams({required this.userId});

  /// The user ID whose recently played songs are retrieved.
  final String userId;
}
