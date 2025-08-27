import 'package:flutter/material.dart';
import '../constants/typography.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display Styles
  static TextStyle get displayLarge => AppTypography.displayLargeStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get displayMedium => AppTypography.displayMediumStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get displaySmall => AppTypography.displaySmallStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  // Headline Styles
  static TextStyle get headlineLarge => AppTypography.headlineLargeStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get headlineMedium => AppTypography.headlineMediumStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get headlineSmall => AppTypography.headlineSmallStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  // Title Styles
  static TextStyle get titleLarge => AppTypography.titleLargeStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get titleMedium => AppTypography.titleMediumStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get titleSmall => AppTypography.titleSmallStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  // Body Styles
  static TextStyle get bodyLarge => AppTypography.bodyLargeStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get bodyMedium => AppTypography.bodyMediumStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get bodySmall => AppTypography.bodySmallStyle.copyWith(
    color: AppColors.textSecondary,
  );
  
  // Label Styles
  static TextStyle get labelLarge => AppTypography.labelLargeStyle.copyWith(
    color: AppColors.textPrimary,
  );
  
  static TextStyle get labelMedium => AppTypography.labelMediumStyle.copyWith(
    color: AppColors.textSecondary,
  );
  
  static TextStyle get labelSmall => AppTypography.labelSmallStyle.copyWith(
    color: AppColors.textSecondary,
  );
  
  // Button Styles
  static TextStyle get buttonLarge => AppTypography.buttonLargeStyle.copyWith(
    color: AppColors.textOnPrimary,
  );
  
  static TextStyle get buttonMedium => AppTypography.buttonMediumStyle.copyWith(
    color: AppColors.textOnPrimary,
  );
  
  static TextStyle get buttonSmall => AppTypography.buttonSmallStyle.copyWith(
    color: AppColors.textOnPrimary,
  );
  
  // Special Styles
  static TextStyle get caption => AppTypography.captionStyle.copyWith(
    color: AppColors.textHint,
  );
  
  static TextStyle get overline => AppTypography.overlineStyle.copyWith(
    color: AppColors.textSecondary,
  );
  
  // Status Text Styles
  static TextStyle get successText => AppTypography.bodyMediumStyle.copyWith(
    color: AppColors.success,
  );
  
  static TextStyle get warningText => AppTypography.bodyMediumStyle.copyWith(
    color: AppColors.warning,
  );
  
  static TextStyle get errorText => AppTypography.bodyMediumStyle.copyWith(
    color: AppColors.error,
  );
  
  static TextStyle get infoText => AppTypography.bodyMediumStyle.copyWith(
    color: AppColors.info,
  );
}