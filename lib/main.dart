import 'package:doctor_hunt/core/theme/app_theme.dart';
import 'package:doctor_hunt/presentation/screens/auth/login_screen.dart';
import 'package:doctor_hunt/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:doctor_hunt/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DoctorHunt());
}

class DoctorHunt extends StatelessWidget {
  const DoctorHunt({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(
      const AssetImage("assets/images/background/background.webp"),
      context,
    );

    return GetMaterialApp(
      title: "Doctor Hunt",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      defaultTransition: .cupertino,
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnBoardingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
      ],
    );
  }
}
