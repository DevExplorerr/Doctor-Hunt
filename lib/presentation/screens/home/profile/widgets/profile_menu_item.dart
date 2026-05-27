import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const .only(bottom: 5),
      child: ListTile(
        onTap: onTap,
        contentPadding: const .symmetric(horizontal: 20, vertical: 2),
        leading: Container(
          padding: const .all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
            shape: .circle,
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
        ),
        title: Text(title, style: textTheme.bodyLarge),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.textSecondary,
          size: 16,
        ),
      ),
    );
  }
}
