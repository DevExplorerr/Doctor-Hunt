import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool pushNotifications = true.obs;
    final RxBool emailUpdates = false.obs;
    final textTheme = Theme.of(context).textTheme;

    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "Settings", showCart: false),
          Expanded(
            child: ListView(
              padding: const .all(15),
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  "Account",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: .w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildSettingItem(
                  context,
                  icon: Icons.lock_outline,
                  title: "Change Password",
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.language,
                  title: "Language",
                  trailingText: "English",
                ),

                const SizedBox(height: 25),
                Text(
                  "Notifications",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: .w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 15),
                Obx(
                  () => _buildSettingItem(
                    context,
                    icon: Icons.notifications_active_outlined,
                    title: "Push Notifications",
                    isToggle: true,
                    toggleValue: pushNotifications.value,
                    onToggle: (val) => pushNotifications.value = val,
                  ),
                ),
                Obx(
                  () => _buildSettingItem(
                    context,
                    icon: Icons.email_outlined,
                    title: "Email Updates",
                    isToggle: true,
                    toggleValue: emailUpdates.value,
                    onToggle: (val) => emailUpdates.value = val,
                  ),
                ),

                const SizedBox(height: 25),
                Text(
                  "Other",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: .w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildSettingItem(
                  context,
                  icon: Icons.help_outline,
                  title: "Help & Support",
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.info_outline,
                  title: "About Doctor Hunt",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
    bool isToggle = false,
    bool toggleValue = false,
    Function(bool)? onToggle,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const .only(bottom: 12),
      child: Material(
        color: AppColors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(16),
          side: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
          ),
        ),
        child: ListTile(
          contentPadding: const .symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const .all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: .circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          title: Text(
            title,
            style: textTheme.bodyLarge?.copyWith(fontWeight: .w600),
          ),
          trailing: isToggle
              ? Switch(
                  value: toggleValue,
                  onChanged: onToggle,
                  activeThumbColor: AppColors.primary,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (trailingText != null)
                      Text(
                        trailingText,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
          onTap: isToggle ? null : () {},
        ),
      ),
    );
  }
}
