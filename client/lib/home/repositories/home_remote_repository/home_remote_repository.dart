import 'dart:io';

import 'package:client/core/utils/typedef.dart';

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

  /// to get the all the songs from the remote server
  // ResultFuture<SongModel> getSongs();
}
