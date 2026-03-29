import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeadline extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const CustomHeadline({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xff333333))),
        TextButton(
            onPressed: onPressed,
            child: Text("See all >",
                style: GoogleFonts.rubik(
                    fontSize: 12, color: const Color(0xff677294))))
      ],
    );
  }
}
