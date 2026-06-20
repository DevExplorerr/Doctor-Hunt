import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheet {
  static void show({required String title, required List<Widget> actions}) {
    Get.bottomSheet(
      isScrollControlled: true,
      Material(
        color: AppColors.white,
        borderRadius: const .vertical(top: .circular(24)),
        child: Padding(
          padding: const .all(24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    borderRadius: .circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: Theme.of(
                  Get.context!,
                ).textTheme.titleLarge?.copyWith(fontWeight: .w700),
              ),
              const SizedBox(height: 20),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const BottomSheetActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: const TextStyle(fontWeight: .w500)),
      contentPadding: .zero,
      onTap: onTap,
    );
  }
}
