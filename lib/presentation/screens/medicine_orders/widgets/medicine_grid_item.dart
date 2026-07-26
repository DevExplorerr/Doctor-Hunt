import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MedicineGridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const MedicineGridItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const .all(.circular(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          CircleAvatar(
            minRadius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Icon(icon, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: .w600,
            ),
            softWrap: true,
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
