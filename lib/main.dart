import 'package:doctor_app_ui/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:doctor_app_ui/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Doctor Hunt",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboardingscreen': (context) => const OnBoardingScreen(),
      },
    );
  }
}
