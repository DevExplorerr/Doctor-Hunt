import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: .TOP,
      backgroundColor: isError
          ? AppColors.error.withValues(alpha: 0.1)
          : AppColors.primary.withValues(alpha: 0.1),
      colorText: AppColors.textPrimary,
      borderRadius: 20,
      margin: const .all(15),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: isError ? AppColors.error : AppColors.primary,
      ),
      duration: const Duration(seconds: 2),
      barBlur: 10,
      borderWidth: 1,
      borderColor: isError
          ? AppColors.favorite.withValues(alpha: 0.2)
          : AppColors.primary.withValues(alpha: 0.2),
    );
  }
}
