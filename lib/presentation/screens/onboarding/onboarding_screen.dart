import 'package:doctor_hunt/controller/onboarding_controller.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/onboarding_button.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingScreen extends GetView<OnBoardingController> {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingController());

    return MainWrapper(
      child: Column(
        children: [
          const SizedBox(height: 50),
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
                    Image.asset(item['image']!, height: 280),
                    const SizedBox(height: 30),
                    Text(
                      item['title']!,
                      style: GoogleFonts.rubik(
                        fontWeight: .bold,
                        color: const Color(0xff333333),
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        item['description']!,
                        textAlign: .center,
                        style: GoogleFonts.rubik(
                          color: const Color(0xff677294),
                          fontSize: 14,
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
          _buildBottomButtons(),
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: controller.currentIndex.value == index ? 20 : 8,
            decoration: BoxDecoration(
              color: controller.currentIndex.value == index
                  ? const Color(0xff0EBE7F)
                  : const Color(0xff677294),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:
            controller.currentIndex.value < controller.onBoardingData.length - 1
            ? Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  TextButton(
                    onPressed: controller.skipToLogin,
                    child: Text(
                      "Skip",
                      style: GoogleFonts.rubik(color: const Color(0xff677294)),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.goToNextPage,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff0ebe7f),
                    ),
                  ),
                ],
              )
            : OnBoardingButton(
                text: "Get Started",
                onTap: controller.skipToLogin,
              ),
      ),
    );
  }
}
