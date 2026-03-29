import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/home/domain/repositories/home_remote_repository/home_remote_repository.dart';

/// Use case for fetching all available songs.
class GetAllSongsUseCase
    implements UseCaseWithParams<List<SongModel>, GetAllSongsParams> {
  /// Creates a [GetAllSongsUseCase].
  const GetAllSongsUseCase(this._homeRemoteRepository);

  final HomeRemoteRepository _homeRemoteRepository;

  @override
  ResultFuture<List<SongModel>> call(GetAllSongsParams params) =>
      _homeRemoteRepository.getAllSongs();
}

/// Parameters for [GetAllSongsUseCase].
class GetAllSongsParams {
  /// Creates [GetAllSongsParams].
  const GetAllSongsParams();
}
