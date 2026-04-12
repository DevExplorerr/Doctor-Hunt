import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    final bool isLoggedIn = AuthRepository.instance.currentUser != null;

    if (!seenOnboarding) {
      await prefs.setBool('seenOnboarding', true);
      Get.offAllNamed('/onboarding');
    } else if (!isLoggedIn) {
      Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Image.asset(
              "assets/app_logo.png",
              height: 90,
              filterQuality: .high,
            ),
            const SizedBox(height: 25),
            Text(
              "Doctor Hunt",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
