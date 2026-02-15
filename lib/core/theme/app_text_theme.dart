import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A utility class for providing TextThemes using Google Fonts.
/// This class cannot be instantiated.
class AppTextTheme {
  // Private constructor to prevent instantiation.
  AppTextTheme._();

  /// The light theme's text styles, using the Work Sans font.
  static TextTheme light =
      GoogleFonts.workSansTextTheme(
        // You can optionally provide a base text theme to apply the font to.
        // For light theme, ThemeData.light().textTheme is the default.
        ThemeData.light().textTheme,
      ).copyWith(
        // Here you can override specific styles if you want.
        // For example, making the display text bolder.
        displayLarge: GoogleFonts.workSans(fontWeight: FontWeight.w700),
      );

  /// The dark theme's text styles, using the Work Sans font.
  static TextTheme dark =
      GoogleFonts.workSansTextTheme(
        // It's crucial to provide the dark theme's base text theme
        // so that the colors are correct for a dark background.
        ThemeData.dark().textTheme,
      ).copyWith(
        // Add any specific overrides for the dark theme here.
        displayLarge: GoogleFonts.workSans(
          fontWeight: FontWeight.w600,
          fontSize: 57.0,
        ),
        displayMedium: GoogleFonts.workSans(
          fontWeight: FontWeight.w600,
          fontSize: 45.0,
        ),
        displaySmall: GoogleFonts.workSans(
          fontWeight: FontWeight.w600,
          fontSize: 36.0,
        ),
        headlineLarge: GoogleFonts.workSans(
          fontWeight: FontWeight.w600,
          fontSize: 32.0,
        ),
        headlineMedium: GoogleFonts.workSans(
          fontWeight: FontWeight.w600,
          fontSize: 28.0,
        ),

        headlineSmall: GoogleFonts.workSans(
          fontWeight: FontWeight.w500,
          fontSize: 24.0,
        ),
        titleLarge: GoogleFonts.workSans(
          fontWeight: FontWeight.w500,
          fontSize: 22.0,
        ),
        titleMedium: GoogleFonts.workSans(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        titleSmall: GoogleFonts.workSans(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
        bodyLarge: GoogleFonts.workSans(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        bodyMedium: GoogleFonts.workSans(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodySmall: GoogleFonts.workSans(
          fontWeight: FontWeight.w400,
          fontSize: 12.0,
        ),
        labelLarge: GoogleFonts.workSans(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
        labelMedium: GoogleFonts.workSans(
          fontWeight: FontWeight.w500,
          fontSize: 12.0,
        ),
        labelSmall: GoogleFonts.workSans(
          fontWeight: FontWeight.w500,
          fontSize: 11.0,
        ),
      );
}
