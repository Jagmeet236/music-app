import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/enums/api_error_type.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/home/model/song_model.dart';
import 'package:client/home/repositories/home_remote_repository/home_remote_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_remote_repository_impl.g.dart';

/// Provides an instance of [HomeRemoteRepositoryImpl] for dependency injection.
@riverpod
HomeRemoteRepositoryImpl homeRemoteRepositoryImpl(Ref ref) {
  return HomeRemoteRepositoryImpl();
}

/// Defines remote data operations for home-related features
/// like song management.
class HomeRemoteRepositoryImpl implements HomeRemoteRepository {
  @override
  ResultFuture<String> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request =
          http.MultipartRequest(
              'POST',
              Uri.parse('${ServerConstant.serverUrl}/song/upload'),
            )
            ..files.addAll([
              await http.MultipartFile.fromPath('song', selectedAudio.path),
              await http.MultipartFile.fromPath(
                'thumbnail',
                selectedThumbnail.path,
              ),
            ])
            ..fields.addAll({
              'artist': artist,
              'song_name': songName,
              'hex_code': hexCode,
            })
            ..headers.addAll({'x-auth-token': token});

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } on http.ClientException {
      return Left(AppFailure(ApiErrorType.network.message));
    } on FormatException {
      return Left(AppFailure(ApiErrorType.badRequest.message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<SongModel>> getAllSongs({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstant.serverUrl}/song/list'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = decoded as List<dynamic>;
        final songs = <SongModel>[];

        for (final item in list) {
          try {
            final song = SongModel.fromJson(item as DataMap);
            songs.add(song);
          } on Exception catch (e) {
            // Optionally log or handle malformed entry
            debugPrint('Failed to parse song item: $e');
          }
        }

        return Right(songs);
      } else {
        final errorMap = decoded is DataMap ? decoded : <String, dynamic>{};

        final errorMessage =
            errorMap['message']?.toString() ??
            errorMap['detail']?.toString() ??
            'Unexpected error occurred';

        return Left(AppFailure(errorMessage));
      }
    } on http.ClientException {
      return Left(AppFailure(ApiErrorType.network.message));
    } on FormatException {
      return Left(AppFailure(ApiErrorType.badRequest.message));
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }
}
