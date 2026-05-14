import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onReset;
  final bool showReset;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onReset,
    this.showReset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: 50, left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: AppColors.icon),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 10),

          // Dynamic Title
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: .ellipsis,
            ),
          ),

          // Custom Action (Reset Button)
          if (showReset)
            GestureDetector(
              onTap: onReset,
              child: Container(
                padding: const .all(6),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  shape: .circle,
                ),
                child: const Icon(Icons.close, size: 18, color: AppColors.red),
              ),
            ),
        ],
      ),
    );
  }
}
