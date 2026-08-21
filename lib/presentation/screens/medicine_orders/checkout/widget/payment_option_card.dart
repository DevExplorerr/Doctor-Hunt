import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentOptionCard({
    super.key,
    required this.title,
    required this.icon,
    this.isActive = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.white,
          border: .all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey.withValues(alpha: 0.2),
          ),
          borderRadius: .circular(12),
          backgroundBlendMode: isActive ? null : BlendMode.multiply,
        ),
        child: Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (!isActive)
                Container(
                  padding: const .symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.2),
                    borderRadius: .circular(8),
                  ),
                  child: const Text(
                    "Coming Soon",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                )
              else if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
