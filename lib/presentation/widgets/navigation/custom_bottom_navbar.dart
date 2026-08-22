import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final List<IconData> navIcons = [
      Icons.home_rounded,
      Icons.calendar_month_rounded,
      Icons.local_pharmacy,
      Icons.person,
    ];

    return SafeArea(
      child: Padding(
        padding: const .only(left: 20, right: 20, bottom: 20),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: .circular(35),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double tabWidth = constraints.maxWidth / navIcons.length;
              return Stack(
                children: [
                  StretchyIndicator(
                    selectedIndex: selectedIndex,
                    tabWidth: tabWidth,
                  ),
                  Row(
                    children: List.generate(navIcons.length, (index) {
                      final bool isSelected = selectedIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onItemTapped(index),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                navIcons[index],
                                key: ValueKey<bool>(isSelected),
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.icon,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class StretchyIndicator extends StatefulWidget {
  final int selectedIndex;
  final double tabWidth;

  const StretchyIndicator({
    super.key,
    required this.selectedIndex,
    required this.tabWidth,
  });

  @override
  State<StretchyIndicator> createState() => _StretchyIndicatorState();
}

class _StretchyIndicatorState extends State<StretchyIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _oldIndex;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _oldIndex = widget.selectedIndex;
    _currentIndex = widget.selectedIndex;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..value = 1.0;
  }

  @override
  void didUpdateWidget(StretchyIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _oldIndex = _currentIndex;
      _currentIndex = widget.selectedIndex;
      _controller.forward(from: 0.0);
    }
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
        final progress = _controller.value;

        final oldCenter = _oldIndex * widget.tabWidth + widget.tabWidth / 2;
        final newCenter = _currentIndex * widget.tabWidth + widget.tabWidth / 2;

        double left, right;

        if (newCenter > oldCenter) {
          right =
              (oldCenter + 25) +
              (newCenter - oldCenter) * Curves.easeOutCubic.transform(progress);
          left =
              (oldCenter - 25) +
              (newCenter - oldCenter) * Curves.easeInCubic.transform(progress);
        } else {
          left =
              (oldCenter - 25) +
              (newCenter - oldCenter) * Curves.easeOutCubic.transform(progress);
          right =
              (oldCenter + 25) +
              (newCenter - oldCenter) * Curves.easeInCubic.transform(progress);
        }

        return Positioned(
          left: left,
          top: 10,
          child: Container(
            height: 40,
            width: right - left,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: .circular(25),
            ),
          ),
        );
      },
    );
  }
}
