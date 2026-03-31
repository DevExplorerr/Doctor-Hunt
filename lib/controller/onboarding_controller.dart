import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final PageController pageController = PageController();
  var currentIndex = 0.obs;

  final List<Map<String, String>> onBoardingData = [
    {
      'image': 'assets/images/onboarding_screen/doctor_1.png',
      'title': 'Find Trusted Doctors',
      'description':
          'Search from a wide network of certified specialists. Read real patient reviews and book with confidence.',
    },
    {
      'image': 'assets/images/onboarding_screen/doctor_2.png',
      'title': 'Choose Best Doctors',
      'description':
          'Compare doctors based on experience, proximity, and availability to ensure you get the best care possible.',
    },
    {
      'image': 'assets/images/onboarding_screen/doctor_3.png',
      'title': 'Easy Appointments',
      'description':
          'Skip the waiting room. Book, manage, and reschedule your health appointments with just a few taps.',
    },
  ];

  void updateIndex(int index) => currentIndex.value = index;

  void goToNextPage() {
    if (currentIndex.value < onBoardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      skipToLogin();
    }
  }

  void skipToLogin() => Get.offAllNamed('/login');

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
