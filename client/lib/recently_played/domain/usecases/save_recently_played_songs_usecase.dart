import 'package:client/core/error/failure.dart';
import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/recently_played/domain/repositories/recently_played_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for saving the recently played songs list.
class SaveRecentlyPlayedSongsUseCase
    implements UseCaseWithParams<void, SaveRecentlyPlayedSongsParams> {
  /// Creates a [SaveRecentlyPlayedSongsUseCase].
  const SaveRecentlyPlayedSongsUseCase(this._repository);

  final RecentlyPlayedRepository _repository;

  @override
  ResultFuture<void> call(SaveRecentlyPlayedSongsParams params) async {
    try {
      await _repository.saveRecentlyPlayedSongs(params.userId, params.songs);
      return const Right(null);
    }on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}

/// Parameters for [SaveRecentlyPlayedSongsUseCase].
class SaveRecentlyPlayedSongsParams {
  /// Creates [SaveRecentlyPlayedSongsParams].
  const SaveRecentlyPlayedSongsParams({
    required this.userId,
    required this.songs,
  });

  /// The user ID whose recently played songs are saved.
  final String userId;

  /// The list of recently played songs to save.
  final List<SongModel> songs;
}
