import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EmergencyWarningCard extends StatelessWidget {
  final VoidCallback onBrowseDoctors;

  const EmergencyWarningCard({super.key, required this.onBrowseDoctors});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const .all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: .circular(20),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                padding: const .all(8),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: .circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Seek Emergency Care Immediately",
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: .w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Your symptoms may indicate a serious condition. Please go to "
            "the nearest emergency room or call your local emergency "
            "services right away — do not wait for an appointment.",
            style: textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onBrowseDoctors,
              icon: const Icon(
                Icons.search_rounded,
                size: 18,
                color: AppColors.error,
              ),
              label: Text(
                "Browse Available Doctors",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: .w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
                padding: const .symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
