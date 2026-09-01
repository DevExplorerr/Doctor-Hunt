import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/triage/symptom_checker_controller.dart';

class RecordingPanel extends StatelessWidget {
  final VoidCallback? onStop;
  final VoidCallback? onCancel;

  const RecordingPanel({
    super.key,
    required this.onStop,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SymptomCheckerController>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            const _PulsingRedDot(),
            const SizedBox(width: 8),
            Text(
              'Listening',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: .w600,
              ),
            ),
            const Spacer(),
            Obx(() {
              final seconds = controller.recordingSeconds.value;
              final minutes = seconds ~/ 60;
              final remaining = seconds % 60;
              return Text(
                '${minutes.toString().padLeft(2, '0')}:'
                '${remaining.toString().padLeft(2, '0')}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.red,
                  fontWeight: .w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 64),
          padding: const .symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.05),
            borderRadius: .circular(16),
          ),
          child: Obx(() {
            final preview = controller.recordingPreview.value;
            if (preview.isEmpty) {
              return Text(
                'Speak now — your words will appear here…',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  fontStyle: .italic,
                ),
              );
            }
            return Text(
              preview,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                  padding: const .symmetric(vertical: 12),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onStop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                  padding: const .symmetric(vertical: 12),
                ),
                child: Text(onStop == null ? 'Processing…' : 'Stop'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Self-contained pulsing red recording indicator.
class _PulsingRedDot extends StatefulWidget {
  const _PulsingRedDot();

  @override
  State<_PulsingRedDot> createState() => _PulsingRedDotState();
}

class _PulsingRedDotState extends State<_PulsingRedDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 12 + 5 * _controller.value,
          height: 12 + 5 * _controller.value,
          decoration: BoxDecoration(
            color: AppColors.red.withValues(
              alpha: 0.35 + 0.65 * _controller.value,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
