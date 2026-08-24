import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/triage/symptom_checker_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymptomCheckerCard extends StatelessWidget {
  const SymptomCheckerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: const .symmetric(horizontal: 15),
      padding: const .all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: .circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  shape: .circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Smart Symptom Checker",
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: .w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Not sure which specialist to book? Tell us how you're feeling and let our AI guide you.",
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => const SymptomCheckerScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const .symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            ),
            icon: const Icon(Icons.search, size: 18),
            label: Text(
              "Check Symptoms",
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: .w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
