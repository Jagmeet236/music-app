import 'dart:io';

import 'package:client/core/utils/typedef.dart';
import 'package:client/home/data/models/song_model.dart';

/// Defines the contract for remote home data operations.
abstract class HomeRemoteDatasource {
  /// Uploads a new song along with its metadata and associated media files.
  ResultFuture<String> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  });

  /// Retrieves all songs from the remote server.
  ResultFuture<List<SongModel>> getAllSongs({
    required String token,
  });
}
