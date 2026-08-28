import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FollowUpChips extends StatelessWidget {
  final List<String> replies;
  final ValueChanged<String> onSelected;

  const FollowUpChips({
    super.key,
    required this.replies,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const .only(left: 45, bottom: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: replies.map((reply) {
          return GestureDetector(
            onTap: () => onSelected(reply),
            child: Container(
              padding: const .symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: .circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                reply,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: .w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
