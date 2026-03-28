import 'dart:developer';
import 'dart:io';

import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/providers/bottom_nav_provider/bottom_nav_provider.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:client/core/utils/media_picker_util.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/home/presentation/viewmodels/upload_notifier.dart';
import 'package:client/home/presentation/widgets/audio_wave.dart';
import 'package:client/home/presentation/widgets/dotted_thumbnail_selector.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This page allows users to upload songs to the platform.
class UploadSongPage extends ConsumerStatefulWidget {
  ///
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();

  Color selectedColor = Palette.cardColor;

  File? selectedImage;
  File? selectedAudio;

  final formKey = GlobalKey<FormState>();

  Future<void> selectImage() async {
    final pickedImage = await MediaPickerUtil.pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  Future<void> selectAudio() async {
    final pickedAudio = await MediaPickerUtil.pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    if (!formKey.currentState!.validate() ||
        selectedAudio == null ||
        selectedImage == null) {
      showSnackBar(
        context,
        'Please fill in all fields and pick a song & thumbnail.',
      );
      return;
    }
    log('started uploading');

    /// Await upload to block the UI with Loader
    await ref
        .read(uploadNotifierProvider.notifier)
        .upload(
          selectedAudio: selectedAudio!,
          selectedThumbnail: selectedImage!,
          songName: songNameController.text.trim(),
          artist: artistController.text.trim(),
          selectedColor: selectedColor,
        );

    final uploadState = ref.read(uploadNotifierProvider);
    if (!mounted) return;

    if (uploadState.uploadSuccess) {
      ref.read(uploadNotifierProvider.notifier).reset();

      // Reset the form so they know it submitted and can upload another
      setState(() {
        selectedAudio = null;
        selectedImage = null;
        selectedColor = Palette.cardColor;
      });
      songNameController.clear();
      artistController.clear();

      log('Upload success, resetting form and navigating back.');
      showSnackBar(context, 'Song uploaded successfully');
      // smoothly navigate back to home screen
      ref.read(bottomNavIndexProvider.notifier).state = 0;
    } else if (uploadState.errorMessage != null) {
      showSnackBar(context, uploadState.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 20);
    final isUploading = ref.watch(uploadNotifierProvider).isUploading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(uploadSong),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: isUploading ? null : () async => _handleUpload(),
          ),
        ],
      ),
      body:
          isUploading
              ? const Center(child: Loader())
              : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child:
                      selectedImage != null
                          ? SizedBox(
                            width: double.infinity,
                            height: context.height * 0.20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          : const DottedThumbnailSelector(),
                ),
                const SizedBox(height: 40),

                /// AUDIO PICKER
                if (selectedAudio != null)
                  AudioWave(audioPath: selectedAudio!.path)
                else
                  CustomTextField(
                    hintText: 'Pick song',
                    readOnly: true,
                    onTap: selectAudio,
                  ),

                sizedBox,

                /// ARTIST
                CustomTextField(hintText: artist, controller: artistController),

                sizedBox,

                /// SONG NAME
                CustomTextField(
                  hintText: songName,
                  controller: songNameController,
                ),

                sizedBox,

                /// COLOR PICKER
                ColorPicker(
                  pickersEnabled: const {ColorPickerType.wheel: true},
                  color: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  heading: Text(
                    selectColor,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Palette.gradient3,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
