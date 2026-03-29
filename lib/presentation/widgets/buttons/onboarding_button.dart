import 'package:doctor_hunt/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingButton extends StatefulWidget {
  final String text;
  const OnBoardingButton({super.key, required this.text});

  @override
  State<OnBoardingButton> createState() => _OnBoardingButtonState();
}

class _OnBoardingButtonState extends State<OnBoardingButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: screenWidth * 0.02),
        child: Center(
          child: SizedBox(
            height: screenWidth * 0.12,
            width: screenWidth * 0.75,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                ),
                backgroundColor: const Color(0xff0ebe7f),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Text(
                widget.text,
                style: GoogleFonts.rubik(
                  fontSize: screenWidth * 0.045,
                  color: const Color(0xffFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
