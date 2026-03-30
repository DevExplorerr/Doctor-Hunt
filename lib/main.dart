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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboardingscreen': (context) => const OnBoardingScreen(),
      },
    );
  }
}
