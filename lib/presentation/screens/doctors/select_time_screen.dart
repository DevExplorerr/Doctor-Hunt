// ignore_for_file: deprecated_member_use

import 'package:doctor_hunt/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectTimeScreen extends StatefulWidget {
  const SelectTimeScreen({super.key});

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  int selectedDateIndex = 0;
  String selectedTime = "";

  final List<String> dates = [
    "Today, 23 Feb",
    "Tomorrow, 24 Feb",
    "Thursday, 25 Feb"
  ];

  final Map<String, List<String>> slots = {
    "Today, 23 Feb": [],
    "Tomorrow, 24 Feb": [
      "1:00 PM",
      "1:30 PM",
      "2:00 PM",
      "2:30 PM",
      "3:00 PM",
      "3:30 PM",
      "4:00 PM",
      "5:00 PM",
      "5:30 PM",
      "6:00 PM",
      "6:30 PM",
      "7:00 PM"
    ],
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String selectedDate = dates[selectedDateIndex];
    bool hasSlots = slots[selectedDate]?.isNotEmpty ?? false;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/select_time_screen/select_time_screen_bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: TopSection(
                  text: 'Select Time',
                  backButton: const Icon(Icons.chevron_left),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _doctorCard(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _dateSelector(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.03),
              hasSlots
                  ? _timeSlots(selectedDate, screenWidth)
                  : _noSlotsAvailable(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _doctorCard(double screenWidth) {
    return Card(
      color: const Color(0xffFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: const AssetImage(
              "assets/images/select_time_screen/timescreendoctor.png"),
          radius: screenWidth * 0.08,
        ),
        title: Text("Dr. Shruti Kedia",
            style: GoogleFonts.rubik(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w500,
                color: const Color(0xff333333))),
        subtitle: Text("Upasana Dental Clinic, Salt Lake",
            style: GoogleFonts.rubik(
                fontSize: screenWidth * 0.035,
                color: const Color(0xff677294),
                fontWeight: FontWeight.w300)),
        trailing: const Icon(Icons.favorite, color: Color(0xffFF0000)),
      ),
    );
  }

  Widget _dateSelector(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(dates.length, (index) {
            bool isSelected = index == selectedDateIndex;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDateIndex = index;
                    selectedTime = "";
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff0EBE7F)
                        : Colors.transparent.withOpacity(0.01),
                    border: Border.all(
                        color: const Color(0xff333333).withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dates[index],
                    style: GoogleFonts.rubik(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xffFFFFFF)
                            : const Color(0xff677294)),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget _noSlotsAvailable(double screenWidth) {
    return Column(
      children: [
        Text("No slots available",
            style: GoogleFonts.rubik(
                fontSize: screenWidth * 0.04,
                color: const Color(0xff677294),
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 20),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xff0EBE7F),
              borderRadius: BorderRadius.circular(6)),
          child: Center(
            child: Text("Next availability on Wed, 24 Feb",
                style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: const Color(0xffFFFFFF),
                    fontWeight: FontWeight.w500)),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "OR",
          style: GoogleFonts.rubik(
              color: const Color(0xff677294),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 54,
          width: 306,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              side: const BorderSide(color: Color(0xff0EBE7F)),
            ),
            child: const Text("Contact Clinic",
                style: TextStyle(color: Color(0xff0EBE7F))),
          ),
        ),
      ],
    );
  }

  Widget _timeSlots(String date, double screenWidth) {
    List<String> times = slots[date] ?? [];
    return Expanded(
      child: ListView(
        children: [
          Text("Afternoon 7 slots",
              style: GoogleFonts.rubik(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff222222))),
          const SizedBox(
            height: 12,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: times
                .sublist(0, 7)
                .map((time) => _timeSlotButton(time, screenWidth))
                .toList(),
          ),
          const SizedBox(height: 15),
          Text("Evening 5 slots",
              style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff222222))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: times
                .sublist(7)
                .map((time) => _timeSlotButton(time, screenWidth))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _timeSlotButton(String time, double screenWidth) {
    bool isSelected = selectedTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.025,
          horizontal: screenWidth * 0.05,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff0EBE7F)
              : Colors.transparent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(time,
            style: TextStyle(
                color: isSelected
                    ? const Color(0xffFFFFFF)
                    : const Color(0xff0EBE7F))),
      ),
    );
  }
}
