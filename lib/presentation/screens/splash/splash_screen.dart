import 'package:doctor_app_ui/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/splash_screen/splash_screen_bg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage("assets/images/splash_screen/Frame.jpg"),
                  height: 70,
                  width: 70),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Doctor Hunt",
                style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25),
              )
            ],
          )),
    );
  }
}
