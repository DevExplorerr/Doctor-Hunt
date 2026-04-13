import 'package:doctor_hunt/core/theme/app_theme.dart';
import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/firebase_options.dart';
import 'package:doctor_hunt/presentation/screens/auth/login_screen.dart';
import 'package:doctor_hunt/presentation/screens/auth/signup_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/home_screen.dart';
import 'package:doctor_hunt/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:doctor_hunt/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthRepository());
  Get.put(DoctorRepository());

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
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}
