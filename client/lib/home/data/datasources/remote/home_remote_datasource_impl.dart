import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/enums/api_error_type.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/core/network/web_api_service.dart';
import 'package:client/core/network/web_api_service_provider.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_remote_datasource_impl.g.dart';

/// Provides an instance of [HomeRemoteDatasourceImpl] for
///  remote home data operations.
@riverpod
HomeRemoteDatasource homeRemoteDatasource(HomeRemoteDatasourceRef ref) {
  final api = ref.watch(webApiServiceProvider);
  return HomeRemoteDatasourceImpl(api);
}

/// Concrete implementation of [HomeRemoteDatasource]
///  that communicates with the remote server.
class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  /// Creates an instance of [HomeRemoteDatasourceImpl]
  ///  with the provided [WebApiService].
  HomeRemoteDatasourceImpl(this._api);

  final WebApiService _api;

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
      final response = await _api.multipartPost(
        url: '${ServerConstant.serverUrl}/song/upload',
        fields: {'artist': artist, 'song_name': songName, 'hex_code': hexCode},
        files: {'song': selectedAudio, 'thumbnail': selectedThumbnail},
        headers: {'x-auth-token': token},
      );

      final body = await response.stream.bytesToString();

      if (response.statusCode != 201) {
        return Left(AppFailure(body));
      }

      return Right(body);
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on FormatException {
      return Left(AppFailure(ApiErrorType.badRequest.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }

  @override
  ResultFuture<List<SongModel>> getAllSongs({required String token}) async {
    try {
      final response = await _api.request(
        url: '${ServerConstant.serverUrl}/song/list',
        method: 'GET',
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = decoded as List<dynamic>;
        final songs =
            list.map((e) => SongModel.fromJson(e as DataMap)).toList();
        return Right(songs);
      } else {
        final message =
            decoded is DataMap
                ? decoded['message']?.toString() ??
                    decoded['detail']?.toString() ??
                    'Unexpected error occurred'
                : 'Unexpected error occurred';

        return Left(AppFailure(message));
      }
    } on TimeoutException {
      return Left(AppFailure(ApiErrorType.timeout.message));
    } on FormatException {
      return Left(AppFailure(ApiErrorType.badRequest.message));
    } on Exception catch (e) {
      return Left(AppFailure('Unexpected error: $e'));
    }
  }
}
