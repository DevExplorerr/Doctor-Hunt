// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorLiveChatScreen extends StatefulWidget {
  const DoctorLiveChatScreen({super.key});

  @override
  State<DoctorLiveChatScreen> createState() => _DoctorLiveChatScreenState();
}

class _DoctorLiveChatScreenState extends State<DoctorLiveChatScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/live_doctor_screen/livedoctorbg.png",
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay for better readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),

          // Chat Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button & Icons
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: screenHeight * 0.05,
                          width: screenHeight * 0.05,
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.arrow_back,
                              color: const Color(0xff677294),
                              size: screenWidth * 0.05),
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: const AssetImage(
                            'assets/images/live_doctor_screen/livetopleft.png'),
                        radius: screenWidth * 0.06,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Chat Messages List
                _buildChatMessage(
                    "assets/images/live_doctor_screen/user1.png",
                    "Everhart Tween",
                    "Thanks for sharing doctor",
                    true,
                    screenWidth),
                _buildChatMessage(
                    "assets/images/live_doctor_screen/user2.png",
                    "Bonebrake Mash",
                    "They treat immune system disorders",
                    false,
                    screenWidth),
                _buildChatMessage(
                    "assets/images/live_doctor_screen/user3.png",
                    "Handler Wack",
                    "This is the largest directory",
                    false,
                    screenWidth),
                _buildChatMessage(
                    "assets/images/live_doctor_screen/user4.png",
                    "Comfort Love",
                    "Depending on their education",
                    true,
                    screenWidth),

                SizedBox(height: screenHeight * 0.02),

                // Message Input Field
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Add a Comment...",
                            style: GoogleFonts.rubik(
                              color: const Color(0xff677294),
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      CircleAvatar(
                        backgroundColor: const Color(0xff0EBE7E),
                        radius: screenWidth * 0.06,
                        child: Icon(Icons.send,
                            color: const Color(0xffFFFFFF),
                            size: screenWidth * 0.05),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(
      String avatar, String name, String message, bool liked, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.015,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(avatar),
            radius: screenWidth * 0.07,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ],
            ),
          ),
          if (liked)
            Icon(Icons.favorite,
                color: const Color(0xffFF5023), size: screenWidth * 0.05),
        ],
      ),
    );
  }
}

