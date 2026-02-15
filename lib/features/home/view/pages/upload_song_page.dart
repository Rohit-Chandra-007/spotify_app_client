import 'dart:io';

import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_text_form_field.dart';
import 'package:client/core/widgets/loaders.dart';
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
    super.dispose();
    _songNameController.dispose();
    _artistNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeModelViewProvider.select((value) => value?.isLoading == true),
    );
    ref.listen(homeModelViewProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, 'Song uploaded successfully!');
          ref.invalidate(getAllSongsProvider);
          Navigator.pop(context);
        },
        error: (error, stackTrace) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return isLoading
        ? CircularLoader()
        : Scaffold(
            appBar: AppBar(
              title: Text("Upload Song"),
              actions: [
                IconButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedAudio != null &&
                        _selectedImage != null) {
                      await ref
                          .read(homeModelViewProvider.notifier)
                          .uploadSong(
                            selectedAudio: _selectedAudio!,
                            selectedImage: _selectedImage!,
                            songName: _songNameController.text,
                            artistName: _artistNameController.text,
                            color: colorToHexCode(selectedColor),
                          );
                    } else {
                      showSnackBar(context, 'Please fill all the fields');
                    }
                  },
                  icon: Icon(Icons.upload),
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
                      GestureDetector(
                        onTap: selectImage,
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImage!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
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
                                      Icon(Icons.folder_rounded, size: 40),
                                      Text(
                                        'Select thumbnail for Song',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 10),
                      _selectedAudio != null
                          ? AudioWave(wavePath: _selectedAudio!.path)
                          : CustomTextFormField(
                              hint: 'Pick Song',
                              controller: null,
                              readOnly: true,
                              onTap: selectSong,
                            ),
                      CustomTextFormField(
                        hint: 'Song Name',
                        controller: _songNameController,
                      ),
                      CustomTextFormField(
                        hint: 'Artist Name',
                        controller: _artistNameController,
                      ),
                      ColorPicker(
                        heading: Text('Select Color'),
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
}
