import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const OnBoardingButton({super.key, required this.text, required this.onTap});

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
              onPressed: onTap,
              child: Text(
                text,
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
