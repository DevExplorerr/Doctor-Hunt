import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/triage_response_model.dart';
import 'package:flutter/material.dart';

class FollowUpChips extends StatelessWidget {
  final List<FollowUpQuestion> questions;
  final ValueChanged<String> onSelected;

  const FollowUpChips({
    super.key,
    required this.questions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final chipQuestions = questions.where((q) => q.hasChips).take(2).toList();

    if (chipQuestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const .only(left: 45, bottom: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          for (final question in chipQuestions) ...[
            Padding(
              padding: const .only(bottom: 8),
              child: Text(
                question.question,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: .w500,
                ),
              ),
            ),
            Padding(
              padding: const .only(bottom: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in question.options)
                    _buildOptionChip(context, option),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionChip(BuildContext context, String option) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => onSelected(option),
      child: Container(
        padding: const .symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          option,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: .w500,
          ),
        ),
      ),
    );
  }
}
