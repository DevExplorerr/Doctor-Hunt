import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopSection extends StatelessWidget {
  final String? text;
  final Widget? iconButton;
  final Widget? backButton;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  const TopSection({
    super.key,
    this.text,
    this.iconButton,
    this.backButton,
    this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (backButton != null)
            IconButton(
              onPressed: onPressed ?? () {},
              icon: backButton!,
              color: const Color(0xff677294),
            ),
          if (text != null)
            Expanded(
              child: Text(
                text!,
                style: textStyle ?? GoogleFonts.rubik(
                  fontSize: 18,
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (iconButton != null) iconButton!,
        ],
      ),
    );
  }
}
