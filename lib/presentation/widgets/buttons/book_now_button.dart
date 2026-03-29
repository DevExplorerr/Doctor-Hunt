import 'package:doctor_hunt/presentation/screens/doctors/select_time_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookNowButton extends StatelessWidget {
  final String text;
  const BookNowButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const SelectTimeScreen())
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff0ebe7f),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.rubik(
            color: const Color(0xffffffff),
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
