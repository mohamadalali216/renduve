import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_font.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    fontFamily: AppTextStyles.fontFamily, // 🔑 ربط الخط الافتراضي هنا
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.gray,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.gray_light_1,
      error: AppColors.error,
      background: AppColors.gray,
      surface: AppColors.gray_light_2,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onError: AppColors.white,
      onBackground: AppColors.white,
      onSurface: AppColors.black,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.bold_24,
      titleLarge: AppTextStyles.bold_16,
      bodyMedium: AppTextStyles.bold_12,
      bodySmall: AppTextStyles.bold_10,
    ),
  );

  static ThemeData customTheme(Color color) {
    return appTheme.copyWith(
      primaryColor: color,
      colorScheme: appTheme.colorScheme.copyWith(
        primary: color,
      ),
    );
  }
}
