import 'package:flutter/material.dart';
import 'package:project_management_app/core/config/constants/app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
  );
}
