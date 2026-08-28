import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/triage_response_model.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class TriageResultCard extends StatelessWidget {
  final String specialty;
  final TriageUrgency urgency;
  final TriageResult? triage;
  final String? homeCare;
  final bool showFindDoctors;
  final VoidCallback onFindDoctors;
  final VoidCallback onStartNewCheck;

  const TriageResultCard({
    super.key,
    required this.specialty,
    required this.urgency,
    required this.triage,
    required this.homeCare,
    required this.showFindDoctors,
    required this.onFindDoctors,
    required this.onStartNewCheck,
  });

  (String, Color) _urgencyStyle(TriageUrgency value) {
    switch (value) {
      case TriageUrgency.elevated:
        return ('Elevated', const Color(0xFFB7791F));
      case TriageUrgency.urgent:
        return ('Urgent', const Color(0xFFE65100));
      case TriageUrgency.emergency:
        return ('Emergency', AppColors.error);
      case TriageUrgency.normal:
        return ('Normal', AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (urgencyLabel, urgencyColor) = _urgencyStyle(urgency);
    final symptomSummary = triage?.symptomSummary ?? const <String>[];
    final redFlags = triage?.redFlags ?? const <String>[];

    return Container(
      width: double.infinity,
      padding: const .all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: .circle,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Suggested Specialist",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: urgencyColor.withValues(alpha: 0.12),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  urgencyLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: urgencyColor,
                    fontWeight: .w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            specialty,
            style: textTheme.titleLarge?.copyWith(fontWeight: .w700),
          ),
          if (symptomSummary.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              "What you described",
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: .w600,
              ),
            ),
            const SizedBox(height: 6),
            ...symptomSummary.map((item) => _buildSummaryRow(context, item)),
          ],
          if (redFlags.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              "Warning signs to watch",
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: .w600,
              ),
            ),
            const SizedBox(height: 6),
            ...redFlags.map(
              (item) => _buildSummaryRow(context, item, isWarning: true),
            ),
          ],
          if (homeCare != null && homeCare!.trim().isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              "Home care tips",
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: .w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              homeCare!,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          const SizedBox(height: 15),
          Text(
            "This is a preliminary suggestion to help you find the right "
            "specialist — it is not a medical diagnosis.",
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          if (showFindDoctors) ...[
            CustomButton(
              text: "Find Doctors",
              onTap: onFindDoctors,
              borderRadius: 12,
              height: 52,
            ),
            const SizedBox(height: 6),
          ],
          Center(
            child: TextButton.icon(
              onPressed: onStartNewCheck,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              label: Text(
                "Start New Check",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: .w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String text, {
    bool isWarning = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final color = isWarning ? AppColors.error : AppColors.textPrimary;

    return Padding(
      padding: const .only(bottom: 4),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .only(top: 7),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: color, shape: .circle),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(color: color, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
