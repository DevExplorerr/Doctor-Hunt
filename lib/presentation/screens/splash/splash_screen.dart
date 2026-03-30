import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

    Get.offNamed('/onboardingscreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: .infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/images/background/background.webp"),
            fit: .fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Image.asset(
              "assets/app_logo.png",
              height: 90,
              width: 90,
              filterQuality: .high,
            ),
            const SizedBox(height: 25),
            Text(
              "Doctor Hut",
              style: GoogleFonts.rubik(
                fontWeight: .bold,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
