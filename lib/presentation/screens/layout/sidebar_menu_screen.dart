import 'package:doctor_hunt/controllers/menu_controller.dart';
import 'package:doctor_hunt/controllers/profile_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/layout/widgets/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarMenuScreen extends StatelessWidget {
  const SidebarMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    final controller = Get.find<AppMenuController>();
    final textTheme = Theme.of(context).textTheme;

    final currentUser = profileController.user.value;
    final String name = currentUser?.name ?? "Patient";
    final String email = currentUser?.email ?? "Not Available";

    final List<Map<String, dynamic>> menuItemsList = [
      {'icon': Icons.person, 'title': "My Appointments"},
      {'icon': Icons.receipt_long, 'title': "Medical Records"},
      {'icon': Icons.payment, 'title': "Payments"},
      {'icon': Icons.medication, 'title': "Medicine Orders"},
      {'icon': Icons.privacy_tip, 'title': "Privacy & Policy"},
      {'icon': Icons.settings, 'title': "Settings"},
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const .only(left: 15, top: 25, bottom: 40),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 25, child: Icon(Icons.person)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          name,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: .w700,
                          ),
                          overflow: .ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          email,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.white,
                          ),
                          overflow: .ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              ...menuItemsList.map(
                (item) => MenuItems(
                  icon: item['icon'] as IconData,
                  title: item['title'] as String,
                  controller: controller,
                ),
              ),
              const Spacer(),
              MenuItems(
                icon: Icons.logout,
                title: "Logout",
                controller: controller,
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
