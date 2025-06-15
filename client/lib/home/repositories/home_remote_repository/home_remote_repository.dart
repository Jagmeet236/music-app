import 'dart:io';

import 'package:client/core/utils/typedef.dart';
import 'package:client/home/model/song_model.dart';

/// Defines remote data operations for home-related features like song management\
abstract class HomeRemoteRepository {
  /// Uploads a new song along with its metadata and associated media files.
  ResultFuture<String> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  });

  /// Returns a [ResultFuture] that contains either a [List<SongModel>]
  ///  on success or an AppFailure on error.
  ResultFuture<List<SongModel>> getAllSongs({required String token});
}
