import 'dart:async';
import 'dart:io';

import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:client/core/utils/color_util.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/home/data/repositories/home_remote_repository_impl.dart';
import 'package:client/home/domain/usecases/get_all_songs_usecase.dart';
import 'package:client/home/domain/usecases/upload_song_usecase.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

/// ViewModel responsible for handling home feature logic.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  late GetAllSongsUseCase _getAllSongsUseCase;
  late UploadSongUseCase _uploadSongUseCase;

  /// Automatically called when provider is first created
  @override
  FutureOr<List<SongModel>> build() async {
    final repository = ref.watch(homeRemoteRepositoryProvider);
    _getAllSongsUseCase = GetAllSongsUseCase(repository);
    _uploadSongUseCase = UploadSongUseCase(repository);

    // Watch auth state to trigger rebuilds on logout/login changes
    final isAuthenticated = ref.watch(
      currentUserNotifierProvider
          .select((user) => user?.token?.isNotEmpty ?? false),
    );

    if (!isAuthenticated) {
      return []; // User logged out — let auth listener handle navigation
    }

    final result = await _getAllSongsUseCase(const GetAllSongsParams());

    return result.fold(
      (failure) => throw Exception(failure.message),
      (songs) => songs,
    );
  }

  /// Manually refresh songs
  Future<void> fetchSongs() async {
    state = await AsyncValue.guard(() async {
      final result = await _getAllSongsUseCase(const GetAllSongsParams());

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
    state = const AsyncValue.loading();

    final response = await _uploadSongUseCase(UploadSongParams(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
    ));

    await response.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) async {
        // Refresh songs after successful upload
        await fetchSongs();
      },
    );
  }
}
