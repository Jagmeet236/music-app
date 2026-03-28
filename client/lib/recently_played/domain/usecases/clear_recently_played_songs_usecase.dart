import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/recently_played/domain/repositories/recently_played_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for clearing all recently played songs.
class ClearRecentlyPlayedSongsUseCase
    implements UseCaseWithParams<void, ClearRecentlyPlayedSongsParams> {
  /// Creates a [ClearRecentlyPlayedSongsUseCase].
  const ClearRecentlyPlayedSongsUseCase(this._repository);

  final RecentlyPlayedRepository _repository;

  @override
  ResultFuture<void> call(ClearRecentlyPlayedSongsParams params) async {
    try {
      await _repository.clearRecentlyPlayedSongs(params.userId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}

/// Parameters for [ClearRecentlyPlayedSongsUseCase].
class ClearRecentlyPlayedSongsParams {
  /// Creates [ClearRecentlyPlayedSongsParams].
  const ClearRecentlyPlayedSongsParams({required this.userId});

  /// The user ID whose recently played songs are cleared.
  final String userId;
}
