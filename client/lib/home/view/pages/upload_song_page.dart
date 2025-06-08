import 'dart:io';

import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils/custom_snack_bar.dart';
import 'package:client/core/utils/media_picker_util.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/home/view/widgets/audio_wave.dart';

import 'package:client/home/view/widgets/dotted_thumbnail_selector.dart';
import 'package:client/home/viewmodel/home_viewmodel.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This page allows users to upload songs to the platform.
class UploadSongPage extends ConsumerStatefulWidget {
  /// Constructor for UploadSongPage
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
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
    } else {
      // Handle the case when no image is selected
      debugPrint('No image selected');
    }
  }

  Future<void> selectAudio() async {
    final pickedAudio = await MediaPickerUtil.pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    } else {
      // Handle the case when no audio is selected
      debugPrint('No audio selected');
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((val) => val?.isLoading ?? false),
    );
    const sizedBox = SizedBox(height: 20);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(uploadSong),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              // Handle upload action
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                await ref
                    .read(homeViewModelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      artist: artistController.text,
                      selectedColor: selectedColor,
                    );
              } else {
                showSnackBar(context, 'Missing fields');
              }
            },
          ),
        ],
      ),
      body:
          isLoading
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
                        if (selectedAudio != null)
                          AudioWave(audioPath: selectedAudio!.path)
                        else
                          CustomTextField(
                            hintText: 'Pick song',
                            readOnly: true,
                            onTap: selectAudio,
                          ),
                        sizedBox,
                        CustomTextField(
                          hintText: artist,
                          controller: artistController,
                        ),
                        sizedBox,
                        CustomTextField(
                          hintText: songName,
                          controller: songNameController,
                        ),
                        sizedBox,
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
