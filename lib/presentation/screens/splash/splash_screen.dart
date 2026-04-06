import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    Get.offNamed('/onboarding');
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
