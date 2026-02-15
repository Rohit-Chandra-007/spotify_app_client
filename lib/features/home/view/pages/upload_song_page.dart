import 'dart:io';

import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_text_form_field.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _artistNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color selectedColor = ColorPallete.cardColor;
  File? _selectedAudio;
  File? _selectedImage;
  bool _isUploading = false;

  void selectSong() async {
    final res = await pickAudio();
    if (res != null) {
      setState(() {
        _selectedAudio = res;
      });
    }
  }

  void selectImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        _selectedImage = res;
      });
    }
  }

  @override
  void dispose() {
    _songNameController.dispose();
    _artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeModelViewProvider, (_, next) {
      next?.when(
        data: (data) {
          setState(() => _isUploading = false);
          showSnackBar(context, 'Song uploaded successfully!');
          ref.invalidate(getAllSongsProvider);
          Navigator.pop(context);
        },
        error: (error, stackTrace) {
          setState(() => _isUploading = false);
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
        actions: [
          _isUploading
              ? const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  onPressed: _handleUpload,
                  icon: const Icon(Icons.upload),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                // ── Thumbnail Picker ──
                GestureDetector(
                  onTap: selectImage,
                  child: _selectedImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImage!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      : DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: const [10, 5],
                            strokeWidth: 2,
                            color: ColorPallete.borderColor,
                            strokeCap: StrokeCap.round,
                            radius: Radius.circular(10),
                          ),
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              spacing: 16,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: ColorPallete.greyColor,
                                ),
                                Text(
                                  'Select thumbnail for Song',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPallete.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 10),

                // ── Audio Picker ──
                if (_selectedAudio != null) ...[
                  AudioWave(wavePath: _selectedAudio!.path),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedAudio!.path
                              .split(Platform.pathSeparator)
                              .last,
                          style: const TextStyle(
                            color: ColorPallete.subtitleText,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: selectSong,
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('Change'),
                      ),
                    ],
                  ),
                ] else
                  GestureDetector(
                    onTap: selectSong,
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        dashPattern: const [10, 5],
                        strokeWidth: 2,
                        color: ColorPallete.borderColor,
                        strokeCap: StrokeCap.round,
                        radius: Radius.circular(10),
                      ),
                      child: SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 12,
                          children: [
                            Icon(
                              Icons.music_note_outlined,
                              size: 30,
                              color: ColorPallete.greyColor,
                            ),
                            Text(
                              'Pick Song',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorPallete.greyColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Song Name ──
                CustomTextFormField(
                  hint: 'Song Name',
                  controller: _songNameController,
                ),

                // ── Artist Name ──
                CustomTextFormField(
                  hint: 'Artist Name',
                  controller: _artistNameController,
                ),

                // ── Color Picker ──
                ColorPicker(
                  heading: const Text('Select Color'),
                  color: selectedColor,
                  pickersEnabled: const {
                    ColorPickerType.primary: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChanged: (Color color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpload() async {
    if (_selectedImage == null) {
      showSnackBar(context, 'Please select a thumbnail image');
      return;
    }
    if (_selectedAudio == null) {
      showSnackBar(context, 'Please select a song file');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isUploading = true);

    await ref
        .read(homeModelViewProvider.notifier)
        .uploadSong(
          selectedAudio: _selectedAudio!,
          selectedImage: _selectedImage!,
          songName: _songNameController.text.trim(),
          artistName: _artistNameController.text.trim(),
          color: colorToHexCode(selectedColor),
        );
  }
}
