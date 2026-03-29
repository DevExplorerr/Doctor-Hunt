import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  const CustomSearchBar({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        height: screenHeight * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.015),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              color: const Color(0xff677294),
              iconSize: screenWidth * 0.05,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.ptSans(
                    color: const Color(0xff677294),
                    fontSize: screenWidth * 0.04,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.close),
              color: const Color(0xff677294),
              iconSize: screenWidth * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
