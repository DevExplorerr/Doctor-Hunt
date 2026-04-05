import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static void show(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: const .symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: .circular(20),
              child: BackdropFilter(
                filter: .blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const .all(25),
                  decoration: BoxDecoration(
                    color: AppColors.bg.withValues(alpha: 0.85),
                  ),
                  child: Material(color: AppColors.transparent, child: child),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }
}
