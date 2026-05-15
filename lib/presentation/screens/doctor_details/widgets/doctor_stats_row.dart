import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DoctorStatsRow extends StatelessWidget {
  final int running;
  final int experience;
  final int patients;

  const DoctorStatsRow({
    super.key,
    required this.running,
    required this.experience,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(15),
      margin: const .symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatBox(context, running, "Running")),
          const SizedBox(width: 12),
          Expanded(child: _buildStatBox(context, experience, "Experience")),
          const SizedBox(width: 12),
          Expanded(child: _buildStatBox(context, patients, "Patients")),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, int value, String label) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: const .all(.circular(10)),
        color: AppColors.secondary.withValues(alpha: 0.1),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            value.toString(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
