import 'package:doctor_hunt/controller/onboarding_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends GetView<OnBoardingController> {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Get.put(OnBoardingController());

    return MainWrapper(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.onBoardingData.length,
              onPageChanged: controller.updateIndex,
              itemBuilder: (context, index) {
                final item = controller.onBoardingData[index];
                return Column(
                  mainAxisAlignment: .center,
                  children: [
                    Image.asset(
                      item['image']!,
                      height: 280,
                      filterQuality: .high,
                    ),
                    const SizedBox(height: 30),
                    Text(item['title']!, style: textTheme.headlineLarge),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const .symmetric(horizontal: 40),
                      child: Text(
                        item['description']!,
                        textAlign: .center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildPageIndicator(),
                  ],
                );
              },
            ),
          ),
          _buildBottomButtons(textTheme),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Obx(
      () => Row(
        mainAxisAlignment: .center,
        children: List.generate(controller.onBoardingData.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const .symmetric(horizontal: 4),
            height: 8,
            width: controller.currentIndex.value == index ? 20 : 8,
            decoration: BoxDecoration(
              color: controller.currentIndex.value == index
                  ? AppColors.primary
                  : AppColors.secondary,
              borderRadius: .circular(8),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomButtons(TextTheme textTheme) {
    return Obx(
      () => Padding(
        padding: const .symmetric(horizontal: 20),
        child:
            controller.currentIndex.value < controller.onBoardingData.length - 1
            ? Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  TextButton(
                    onPressed: controller.skipToLogin,
                    child: Text(
                      "Skip",
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.goToNextPage,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              )
            : CustomButton(text: "Get Started", onTap: controller.skipToLogin),
      ),
    );
  }
}
