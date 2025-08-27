import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Font Sizes - Following Material Design guidelines
  static const double displayLarge = 32.0;
  static const double displayMedium = 28.0;
  static const double displaySmall = 24.0;
  
  static const double headlineLarge = 22.0;
  static const double headlineMedium = 20.0;
  static const double headlineSmall = 18.0;
  
  static const double titleLarge = 16.0;
  static const double titleMedium = 14.0;
  static const double titleSmall = 12.0;
  
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 12.0; // Minimum 12px for accessibility
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  
  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;
  
  // Letter Spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  
  // Text Styles for Arabic content
  static TextStyle get displayLargeStyle => GoogleFonts.tajawal(
    fontSize: displayLarge,
    fontWeight: bold,
    height: lineHeightTight,
  );
  
  static TextStyle get displayMediumStyle => GoogleFonts.tajawal(
    fontSize: displayMedium,
    fontWeight: bold,
    height: lineHeightTight,
  );
  
  static TextStyle get displaySmallStyle => GoogleFonts.tajawal(
    fontSize: displaySmall,
    fontWeight: semiBold,
    height: lineHeightTight,
  );
  
  static TextStyle get headlineLargeStyle => GoogleFonts.tajawal(
    fontSize: headlineLarge,
    fontWeight: semiBold,
    height: lineHeightNormal,
  );
  
  static TextStyle get headlineMediumStyle => GoogleFonts.tajawal(
    fontSize: headlineMedium,
    fontWeight: semiBold,
    height: lineHeightNormal,
  );
  
  static TextStyle get headlineSmallStyle => GoogleFonts.tajawal(
    fontSize: headlineSmall,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  static TextStyle get titleLargeStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: titleLarge,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  static TextStyle get titleMediumStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: titleMedium,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  static TextStyle get titleSmallStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: titleSmall,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  static TextStyle get bodyLargeStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: bodyLarge,
    fontWeight: regular,
    height: lineHeightRelaxed,
  );
  
  static TextStyle get bodyMediumStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: bodyMedium,
    fontWeight: regular,
    height: lineHeightRelaxed,
  );
  
  static TextStyle get bodySmallStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: bodySmall,
    fontWeight: regular,
    height: lineHeightNormal,
  );
  
  static TextStyle get labelLargeStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: labelLarge,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  static TextStyle get labelMediumStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: labelMedium,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  static TextStyle get labelSmallStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: labelSmall,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  // Button text styles
  static TextStyle get buttonLargeStyle => GoogleFonts.tajawal(
    fontSize: titleLarge,
    fontWeight: semiBold,
    height: lineHeightNormal,
  );
  
  static TextStyle get buttonMediumStyle => GoogleFonts.tajawal(
    fontSize: titleMedium,
    fontWeight: semiBold,
    height: lineHeightNormal,
  );
  
  static TextStyle get buttonSmallStyle => GoogleFonts.tajawal(
    fontSize: titleSmall,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  // Caption and overline styles
  static TextStyle get captionStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: bodySmall,
    fontWeight: regular,
    height: lineHeightNormal,
  );
  
  static TextStyle get overlineStyle => GoogleFonts.ibmPlexSansArabic(
    fontSize: labelSmall,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );
}