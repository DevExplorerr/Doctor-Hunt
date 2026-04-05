import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OverlayLoader extends StatelessWidget {
  const OverlayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ModalBarrier(dismissible: false, color: AppColors.transparent),
        BackdropFilter(
          filter: .blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: .circle,
                color: AppColors.white,
              ),
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.primary,
                size: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
