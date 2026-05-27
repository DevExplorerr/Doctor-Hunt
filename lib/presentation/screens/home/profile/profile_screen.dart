import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/controllers/profile_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/home/profile/widgets/profile_menu_item.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final textTheme = Theme.of(context).textTheme;

    return MainWrapper(
      child: Column(
        children: [
          CustomAppBar(
            title: "My Profile",
            onBackPressed: () {
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().changeTabIndex(0);
              } else {
                Get.back();
              }
            },
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.user.value == null) {
                return Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.primary,
                    size: 40,
                  ),
                );
              }

              final currentUser = controller.user.value;
              final String displayName = currentUser?.name ?? "Patient";
              final String displayEmail = currentUser?.email ?? "Not Available";
              final String avatarUrl = currentUser?.avatar ?? "";

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: const .symmetric(horizontal: 20),
                      padding: const .all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: .circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              shape: .circle,
                              border: .all(color: AppColors.white, width: 2),
                            ),
                            child: ClipOval(
                              child: avatarUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: avatarUrl,
                                      fit: .cover,
                                      placeholder: (_, __) => Container(
                                        color: AppColors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                      errorWidget: (_, __, ___) => const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: AppColors.white,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  displayName,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: AppColors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  displayEmail,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    ProfileMenuItem(
                      icon: Icons.edit_rounded,
                      title: "Edit Profile",
                      onTap: () {
                        Get.toNamed('/edit-profile');
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.history_edu_rounded,
                      title: "My Consultations",
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: "Privacy Policy",
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      onTap: () {},
                    ),

                    const Padding(
                      padding: .symmetric(vertical: 10),
                      child: Divider(color: AppColors.bg),
                    ),

                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      title: "Sign Out",
                      iconColor: AppColors.red,
                      textColor: AppColors.red,
                      onTap: () => _showLogoutConfirmation(context, controller),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(
    BuildContext context,
    ProfileController controller,
  ) {
    CustomDialog.show(
      context,
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            "Sign Out",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
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
                child: CustomButton(
                  height: 45,
                  text: "Sign Out",
                  isLoading: controller.isLoading.value,
                  onTap: () {
                    Get.back();
                    controller.logout();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
