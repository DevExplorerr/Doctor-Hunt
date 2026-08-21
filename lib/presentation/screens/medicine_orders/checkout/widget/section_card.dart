import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(horizontal: 15),
      width: double.infinity,
      padding: const .all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(16),
        border: .all(color: AppColors.textSecondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .w700),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}
