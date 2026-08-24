import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ThinkingLoader extends StatefulWidget {
  const ThinkingLoader({super.key});

  @override
  State<ThinkingLoader> createState() => _ThinkingLoaderState();
}

class _ThinkingLoaderState extends State<ThinkingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Thinking", style: TextStyle(color: AppColors.grey)),
        const SizedBox(width: 8),
        ...List.generate(3, (index) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index * 0.2,
                0.6 + index * 0.2,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              margin: const .symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: .circle,
              ),
            ),
          );
        }),
      ],
    );
  }
}
