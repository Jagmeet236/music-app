import 'dart:io';

import 'package:client/core/usecases/usecase.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/home/domain/repositories/home_remote_repository/home_remote_repository.dart';

/// Use case for uploading a new song.
class UploadSongUseCase implements UseCaseWithParams<String, UploadSongParams> {
  /// Creates an [UploadSongUseCase].
  const UploadSongUseCase(this._homeRemoteRepository);

  final HomeRemoteRepository _homeRemoteRepository;

  @override
  ResultFuture<String> call(UploadSongParams params) =>
      _homeRemoteRepository.uploadSong(
        selectedAudio: params.selectedAudio,
        selectedThumbnail: params.selectedThumbnail,
        songName: params.songName,
        artist: params.artist,
        hexCode: params.hexCode,
        token: params.token,
      );
}

/// Parameters for [UploadSongUseCase].
class UploadSongParams {
  /// Creates [UploadSongParams].
  const UploadSongParams({
    required this.selectedAudio,
    required this.selectedThumbnail,
    required this.songName,
    required this.artist,
    required this.hexCode,
    required this.token,
  });

  /// The audio file to upload.
  final File selectedAudio;

  /// The thumbnail file.
  final File selectedThumbnail;

  /// The song's name.
  final String songName;

  /// The artist's name.
  final String artist;

  /// The selected color hex code.
  final String hexCode;

  /// The user token.
  final String token;
}
