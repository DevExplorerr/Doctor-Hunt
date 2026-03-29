// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';

class OrderSuccesScreen extends StatelessWidget {
  const OrderSuccesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff212121).withOpacity(0.79),
      body: Center(
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: const Color(0xffFFFFFF),
          child: Container(
            height: height * 0.6,
            width: width * 0.85,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.03,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: width * 0.35,
                  width: width * 0.35,
                  decoration: const BoxDecoration(
                    color: Color(0xffE7F8F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.thumb_up,
                      color: const Color(0xff0EBE7F), size: width * 0.18),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Thank You!",
                  style: GoogleFonts.rubik(
                    fontSize: width * 0.09,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff333333),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  "Your Order is Successfully Placed",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff677294),
                  ),
                ),
                SizedBox(height: height * 0.015),
                Text(
                  "You will receive a confirmation shortly.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff677294),
                  ),
                ),
                SizedBox(height: height * 0.03),
                SizedBox(
                  width: double.infinity,
                  height: height * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(() => const HomeScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0EBE7F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Done",
                      style: GoogleFonts.rubik(
                        fontSize: width * 0.045,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
