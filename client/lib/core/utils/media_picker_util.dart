import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Utility class for picking media files
class MediaPickerUtil {
  /// Function to pick an audio file using FilePicker
  static Future<File?> pickAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.xFile.path;
        return File(path);
      }
      return null; // No file was selected
    } on Exception catch (e) {
      debugPrint('Error picking audio file: $e');
      return null; // Return null if an error occurs
    }
  }

  /// Function to pick an image file using FilePicker
  static Future<File?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.xFile.path;
        return File(path);
      }
      return null; // No file was selected
    } on Exception catch (e) {
      debugPrint('Error picking image file: $e'); // Fixed error message
      return null; // Return null if an error occurs
    }
  }
}
