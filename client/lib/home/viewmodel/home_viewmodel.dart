import 'dart:io';

import 'package:client/core/providers/current_user_notifier/current_user_notifier.dart';
import 'package:client/core/utils/color_util.dart';
import 'package:client/home/model/song_model.dart';
import 'package:client/home/repositories/home_remote_repository/home_remote_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
/// Retrieves all songs from the remote server using the
/// authenticated user's token.
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user?.token),
  );

  if (token == null || token.isEmpty) {
    throw Exception('User token is missing');
  }

  final res = await ref
      .read(homeRemoteRepositoryImplProvider)
      .getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw Exception(l.message),
    Right(value: final r) => r,
  };
}

/// ViewModel to manage home-related logic such as uploading songs.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRemoteRepositoryImpl _homeRemoteRepositoryImpl;

  @override
  AsyncValue<dynamic>? build() {
    _homeRemoteRepositoryImpl = ref.watch(homeRemoteRepositoryImplProvider);
    return null;
  }

  /// Uploads a song and updates the UI state accordingly.
  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final response = await _homeRemoteRepositoryImpl.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token ?? '',
    );
    final val = switch (response) {
      Left(value: final l) =>
        state = AsyncError<String>(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint('Upload Song Response: $val');
  }
}
