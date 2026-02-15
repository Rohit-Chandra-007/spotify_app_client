import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<File?> pickAudio() async {
  try {
    final res = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (res != null) {
      return File(res.files.first.path!);
    }
    return null;
  } catch (e) {
    return null;
  }
}

// color to hex code
String colorToHexCode(Color color) {
  final r = (color.r * 255.0)
      .round()
      .clamp(0, 255)
      .toRadixString(16)
      .padLeft(2, '0');
  final g = (color.g * 255.0)
      .round()
      .clamp(0, 255)
      .toRadixString(16)
      .padLeft(2, '0');
  final b = (color.b * 255.0)
      .round()
      .clamp(0, 255)
      .toRadixString(16)
      .padLeft(2, '0');

  return '$r$g$b';
}

// hex to color
Color hexToColor(String hex) {
  final r = int.parse(hex.substring(0, 2), radix: 16);
  final g = int.parse(hex.substring(2, 4), radix: 16);
  final b = int.parse(hex.substring(4, 6), radix: 16);
  return Color.fromARGB(255, r, g, b);
}

Future<File?> pickImage() async {
  try {
    final res = await FilePicker.platform.pickFiles(type: FileType.image);
    if (res != null) {
      return File(res.files.first.path!);
    }
    return null;
  } catch (e) {
    return null;
  }
}
