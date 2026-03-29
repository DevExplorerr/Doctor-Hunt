// ignore_for_file: deprecated_member_use

import 'package:doctor_app_ui/presentation/widgets/buttons/book_now_button.dart';
import 'package:doctor_app_ui/presentation/widgets/search/custom_search_bar.dart';
import 'package:doctor_app_ui/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FindDoctorsScreen extends StatelessWidget {
  const FindDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/find_doctor_screen/find_doctor_screen_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Padding(
          padding: EdgeInsets.only(top: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopSection(
                text: 'Find Doctors',
                backButton: const Icon(Icons.chevron_left),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: screenWidth * 0.04),
              const CustomSearchBar(hintText: "Dentist"),
              SizedBox(height: screenWidth * 0.03),
              Expanded(
                child: ListView(
                  children: [
                    _buildDoctorContainer(
                      "Dr.Shruti Kedia",
                      "Tooths Dentist",
                      "7 Year experience",
                      "10:00 AM tomorrow",
                      "assets/images/find_doctor_screen/find_doctor1.jpg",
                      "87%",
                      "69",
                      true,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    _buildDoctorContainer(
                      "Dr.Watamaniuk",
                      "Tooths Dentist",
                      "9 Year experience",
                      "12:00 AM tomorrow",
                      "assets/images/find_doctor_screen/find_doctor2.jpg",
                      "74%",
                      "78",
                      false,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    _buildDoctorContainer(
                      "Dr.Crownover",
                      "Tooths Dentist",
                      "5 Year experience",
                      "11:00 AM tomorrow",
                      "assets/images/find_doctor_screen/find_doctor3.jpg",
                      "59%",
                      "86",
                      true,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    _buildDoctorContainer(
                      "Dr.Balestra",
                      "Tooths Dentist",
                      "6 Year experience",
                      "1:00 PM tomorrow",
                      "assets/images/find_doctor_screen/find_doctor4.jpg",
                      "87%",
                      "69",
                      false,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    _buildDoctorContainer(
                      "Dr.Shruti Kedia",
                      "Tooths Dentist",
                      "7 Year experience",
                      "10:00 AM tomorrow",
                      "assets/images/find_doctor_screen/find_doctor1.jpg",
                      "85%",
                      "95",
                      true,
                      screenWidth,
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

  Widget _buildDoctorContainer(
    String name,
    String specialty,
    String experience,
    String availableTime,
    String imagePath,
    String percentage,
    String patientStories,
    bool isFavorite,
    double screenWidth,
  ) {
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.05),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  height: screenWidth * 0.2,
                  width: screenWidth * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: GoogleFonts.rubik(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff333333),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? const Color(0xffFF0000) : const Color(0xff677294),
                          size: screenWidth * 0.06,
                        ),
                      ],
                    ),
                    Text(
                      specialty,
                      style: GoogleFonts.ptSans(
                        color: const Color(0xff0ebe7f),
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                    Text(
                      experience,
                      style: GoogleFonts.rubik(
                        color: const Color(0xff677294),
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Color(0xff0ebe7f), size: 10),
                        SizedBox(width: screenWidth * 0.01),
                        Expanded(
                          child: Text(
                            "$percentage  •  $patientStories Patient Stories",
                            style: GoogleFonts.rubik(
                              fontSize: screenWidth * 0.03,
                              color: const Color(0xff677294),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          Text(
            "Next Available",
            style: GoogleFonts.rubik(
              fontSize: screenWidth * 0.035,
              color: const Color(0xff0ebe7f),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            availableTime,
            style: GoogleFonts.rubik(
              fontSize: screenWidth * 0.03,
              color: const Color(0xff677294),
            ),
          ),
          SizedBox(height: screenWidth * 0.03),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: screenWidth * 0.35,
              child: const BookNowButton(text: "Book Now"),
            ),
          ),
        ],
      ),
    );
  }
}
