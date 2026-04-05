import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: .circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 60),
          ),
          const SizedBox(height: 25),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: .center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
