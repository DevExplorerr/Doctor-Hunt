import 'package:doctor_hunt/controllers/menu_controller.dart';
import 'package:doctor_hunt/controllers/profile_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItems extends StatelessWidget {
  final IconData icon;
  final String title;
  final AppMenuController controller;
  final bool isLogout;
  const MenuItems({
    super.key,
    required this.icon,
    required this.title,
    required this.controller,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profileController = Get.put(ProfileController());

    return ListTile(
      splashColor: AppColors.white.withValues(alpha: 0.2),
      leading: Icon(icon, color: AppColors.white),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.white),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(color: AppColors.white),
        softWrap: true,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      minVerticalPadding: 25,
      onTap: () {
        if (isLogout) {
          CustomDialog.show(
            context,
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  "Sign Out",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to logout?",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Cancel",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(
                        () => CustomButton(
                          height: 45,
                          text: "Sign Out",
                          isLoading: profileController.isLoading.value,
                          onTap: () async {
                            await profileController.logout();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          controller.handleMenuRouting(title);
        }
      },
    );
  }
}
