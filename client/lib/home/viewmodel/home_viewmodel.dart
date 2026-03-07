import 'dart:async';
import 'dart:io';

import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:client/core/utils/color_util.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/home/data/repositories/home_remote_repository_impl.dart';
import 'package:client/home/domain/repositories/home_remote_repository/home_remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

/// ViewModel responsible for handling home feature logic.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  late final HomeRemoteRepository _repository;

  /// Automatically called when provider is first created
  @override
  FutureOr<List<SongModel>> build() async {
    _repository = ref.watch(homeRemoteRepositoryProvider);

    final token = ref.watch(
      currentUserNotifierProvider.select((user) => user?.token),
    );

    if (token == null || token.isEmpty) {
      throw Exception('User token is missing');
    }

    final result = await _repository.getAllSongs(token: token);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (songs) => songs,
    );
  }

  /// Manually refresh songs
  Future<void> fetchSongs() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final token =
          ref.read(currentUserNotifierProvider)?.token ?? '';

      if (token.isEmpty) {
        throw Exception('User token is missing');
      }

      final result = await _repository.getAllSongs(token: token);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (songs) => songs,
      );
    });
  }

  /// Uploads a song and refreshes list on success
  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    final token =
        ref.read(currentUserNotifierProvider)?.token ?? '';

    if (token.isEmpty) {
      state = AsyncValue.error(
        'User token is missing',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    final response = await _repository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: token,
    );

    response.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message,
          StackTrace.current,
        );
      },
      (_) async {
        // Refresh songs after successful upload
        await fetchSongs();
      },
    );
  }
}