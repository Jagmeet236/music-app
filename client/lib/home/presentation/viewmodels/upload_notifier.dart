import 'dart:developer';
import 'dart:io';


import 'package:client/core/utils/color_util.dart';
import 'package:client/home/data/repositories/home_remote_repository_impl.dart';
import 'package:client/home/domain/usecases/upload_song_usecase.dart';
import 'package:client/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_notifier.g.dart';

/// Immutable state for an in-progress (or just-finished) upload.
class UploadState {
  /// Creates an [UploadState].
  const UploadState({
    this.isUploading = false,
    this.errorMessage,
    this.uploadSuccess = false,
  });

  /// Whether an upload is currently in flight.
  final bool isUploading;

  /// Non-null when the upload finished with an error.
  final String? errorMessage;

  /// True for one lifecycle tick after a successful upload.
  final bool uploadSuccess;

  /// Returns a copy of this state with the given fields replaced.
  UploadState copyWith({
    bool? isUploading,
    String? errorMessage,
    bool? uploadSuccess,
    bool clearError = false,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
    );
  }
}

/// Manages background song upload without blocking the UI.
@Riverpod(keepAlive: true)
class UploadNotifier extends _$UploadNotifier {
  @override
  UploadState build() => const UploadState();

  /// Starts an upload in the background.
  ///
  /// The caller should **not** await this — fire and forget.
  Future<void> upload({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    log('UploadNotifier.upload called for $songName by $artist');
    
    state = const UploadState(isUploading: true);

    try {
      final repository = ref.read(homeRemoteRepositoryProvider);
      final uploadSongUseCase = UploadSongUseCase(repository);

      log('UploadNotifier: sending to uploadSongUseCase...');
      final response = await uploadSongUseCase(UploadSongParams(
        selectedAudio: selectedAudio,
        selectedThumbnail: selectedThumbnail,
        songName: songName,
        artist: artist,
        hexCode: rgbToHex(selectedColor),
      ));

      response.fold(
        (failure) {
          log('UploadNotifier: API returned failure: ${failure.message}');
          state = UploadState(errorMessage: failure.message);
        },
        (_) {
          log('UploadNotifier: API success! '
          'Invalidating homeViewModelProvider.');
          // Reload the songs list in the background
          ref.invalidate(homeViewModelProvider);
          state = const UploadState(uploadSuccess: true);
        },
      );
    } on Exception catch (e, st) {
      log('UploadNotifier: Unexpected exception: $e\n$st');
      state = UploadState(errorMessage: 'Unexpected error: $e');
    }
  }

  /// Clears the success / error flags after the UI has consumed them.
  void reset() {
    state = const UploadState();
  }
}
