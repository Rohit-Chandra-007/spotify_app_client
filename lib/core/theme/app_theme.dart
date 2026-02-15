import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/material.dart';

import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static _boarder({Color color = ColorPallete.borderColor}) =>
      OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: color),
        borderRadius: BorderRadius.circular(10),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorPallete.backgroundColor,
    textTheme: AppTextTheme.dark,
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: ColorPallete.greyColor, fontSize: 18),
      contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      border: _boarder(),
      enabledBorder: _boarder(color: ColorPallete.borderColor),
      focusedBorder: _boarder(color: ColorPallete.gradient2),
      errorBorder: _boarder(color: ColorPallete.errorColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorPallete.backgroundColor,
      selectedItemColor: ColorPallete.gradient2,
      unselectedItemColor: ColorPallete.greyColor,
      showUnselectedLabels: true,
    ),
  );
}
