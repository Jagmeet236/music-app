import 'dart:io';

import 'package:client/core/error/failure.dart';
import 'package:client/core/utils/typedef.dart';
import 'package:client/home/data/datasources/local/home_local_datasource.dart';
import 'package:client/home/data/datasources/local/home_local_datasource_impl.dart';
import 'package:client/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:client/home/data/datasources/remote/home_remote_datasource_impl.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/home/domain/repositories/home_remote_repository/home_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_remote_repository_impl.g.dart';

/// Provides an instance of [HomeRemoteRepository].
/// ViewModel depends ONLY on this abstraction.
@riverpod
HomeRemoteRepository homeRemoteRepository(HomeRemoteRepositoryRef ref) {
  final remote = ref.watch(homeRemoteDatasourceProvider);
  final local = ref.watch(homeLocalDatasourceProvider);
  return HomeRemoteRepositoryImpl(remote, local);
}

/// Concrete implementation of [HomeRemoteRepository]
/// that delegates logic to [HomeRemoteDatasource] & [HomeLocalDatasource].
class HomeRemoteRepositoryImpl implements HomeRemoteRepository {
  /// Creates a HomeRemoteRepositoryImpl
  ///  with the provided [HomeRemoteDatasource] and [HomeLocalDatasource].
  HomeRemoteRepositoryImpl(this._remote, this._local);

  final HomeRemoteDatasource _remote;
  final HomeLocalDatasource _local;

  @override
  ResultFuture<String> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
  }) async {
    final token = await _local.getTokenAsync();
    
    if (token == null || token.isEmpty) {
      return const Left(AppFailure('User token is missing'));
    }

    return _remote.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: hexCode,
      token: token,
    );
  }

  @override
  ResultFuture<List<SongModel>> getAllSongs() async {
    final token = await _local.getTokenAsync();

    if (token == null || token.isEmpty) {
      return const Left(AppFailure('User token is missing'));
    }

    return _remote.getAllSongs(token: token);
  }
}
