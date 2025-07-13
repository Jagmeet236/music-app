import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Utility class for picking media files.
class MediaPickerUtil {
  static final _validImageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
  ];
  static final _validAudioExtensions = [
    '.mp3',
    '.aac',
    '.wav',
    '.ogg',
    '.flac',
    '.m4a',
  ];

  static bool _hasValidExtension(
    String filePath,
    List<String> validExtensions,
  ) {
    final ext = filePath.toLowerCase();
    return validExtensions.any(ext.endsWith);
  }

  static Future<File?> _pickFile({
    required FileType fileType,
    required List<String> validExtensions,
    required String fileCategory,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: fileType);

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.path;
        if (path == null || path.isEmpty) {
          debugPrint('No path returned for the selected $fileCategory');
          return null;
        }

        final file = File(path);
        if (!await file.exists()) {
          debugPrint('Selected $fileCategory does not exist');
          return null;
        }

        final fileSize = await file.length();
        if (fileSize == 0) {
          debugPrint('Selected $fileCategory is empty');
          return null;
        }

        if (!_hasValidExtension(path, validExtensions)) {
          debugPrint('Invalid $fileCategory file extension');
          return null;
        }

        debugPrint('$fileCategory selected: $path, size: $fileSize bytes');
        return file;
      }

      debugPrint('No $fileCategory selected');
      return null;
    } on Exception catch (e) {
      debugPrint('Error picking $fileCategory: $e');
      return null;
    }
  }

  /// Pick an audio file
  static Future<File?> pickAudio() async {
    return _pickFile(
      fileType: FileType.audio,
      validExtensions: _validAudioExtensions,
      fileCategory: 'audio file',
    );
  }

  /// Pick an image file
  static Future<File?> pickImage() async {
    return _pickFile(
      fileType: FileType.image,
      validExtensions: _validImageExtensions,
      fileCategory: 'image file',
    );
  }
}
