// ignore_for_file: deprecated_member_use

import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:doctor_hunt/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF).withOpacity(0.1),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/profile_screen/profile_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xff0EBE7F),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    TopSection(
                      text: 'Profile',
                      textStyle: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CircleAvatar(
                      radius: screenWidth * 0.15,
                      backgroundImage: const AssetImage(
                        "assets/images/profile_screen/profile.png",
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: screenWidth * 0.05,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            size: screenWidth * 0.04,
                            color: const Color(0xff677294),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "Set up your profile",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Update your profile to connect your doctor with better impression.",
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal information",
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.045,
                        color: const Color(0xff333333),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    buildTextField("Name", "Abdullah Mamun", screenWidth),
                    SizedBox(height: screenHeight * 0.015),
                    buildTextField(
                      "Contact Number",
                      "+8801800000000",
                      screenWidth,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    buildTextField("Date of birth", "DD MM YYYY", screenWidth),
                    SizedBox(height: screenHeight * 0.015),
                    buildTextField("Location", "Add Details", screenWidth),
                    SizedBox(height: screenHeight * 0.03),
                    CustomButton(
                      text: "Logout",
                      onTap: () {
                        CustomDialog.show(
                          context,
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                "Logout",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: AppColors.primary),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Are you sure you want to logout?",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomButton(
                                      height: 50,
                                      text: "Logout",
                                      onTap: () {
                                        AuthRepository.instance.logout();
                                        AppSnackBar.show(
                                          title: "Success",
                                          message: "Logout Successfully",
                                          snackPosition: .TOP,
                                        );
                                        Get.offAllNamed('/login');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hintText, double screenWidth) {
    return TextField(
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.rubik(
          color: const Color(0xff0EBE7F),
          fontWeight: FontWeight.w500,
          fontSize: screenWidth * 0.04,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.rubik(
          color: const Color(0xff677294),
          fontWeight: FontWeight.w300,
          fontSize: screenWidth * 0.035,
        ),
        suffixIcon: label == "Contact Number" || label == "Date of birth"
            ? Icon(
                Icons.edit,
                color: const Color(0xff677294),
                size: screenWidth * 0.05,
              )
            : label == "Location"
            ? Icon(
                Icons.location_on,
                color: const Color(0xff677294),
                size: screenWidth * 0.05,
              )
            : null,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: const Color(0xffFFFFFF),
      ),
    );
  }
}
