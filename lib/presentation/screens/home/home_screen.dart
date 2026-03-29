// ignore_for_file: deprecated_member_use

import 'package:doctor_hunt/presentation/screens/home/favorite/favorite_screen.dart';
import 'package:doctor_hunt/presentation/screens/doctors/find_doctors_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/live_chat_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/pharmacy/pharmacy_screen.dart';
import 'package:doctor_hunt/presentation/screens/doctors/popular_doctor_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/profile/profile_screen.dart';
import 'package:doctor_hunt/presentation/widgets/navigation/custom_bottom_navbar.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize with empty widgets or non-context-dependent widgets
    _pages = [
      Container(), // Placeholder
      const FavoriteScreen(),
      const PharmacyScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now it's safe to use MediaQuery
    _pages = [
      _buildHomeContent(),
      const FavoriteScreen(),
      const PharmacyScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home_screen/home_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomSearchBar(hintText: 'Search......'),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _buildLiveDoctors(),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _buildCategories(),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _buildPopularDoctors(),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                _buildFeatureDoctors(),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 50,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0ebe7e), Color(0xff07D9AD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi Handworker!",
                style: GoogleFonts.rubik(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  color: Colors.white,
                ),
              ),
              Text(
                "Find Your Doctor",
                style: GoogleFonts.rubik(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.08,
              backgroundImage: const AssetImage(
                "assets/images/home_screen/profile.png",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDoctors() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorLiveChatScreen()),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Live Doctors",
              style: GoogleFonts.rubik(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.02,
                    ),
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/home_screen/live_doctor/live${index + 1}.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffFA002F),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "LIVE",
                          style: GoogleFonts.rubik(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryIcon("assets/images/home_screen/category/teeth.png", [
              const Color(0xff2753F3),
              const Color(0xff765AFC),
            ]),
            const SizedBox(width: 10),
            _buildCategoryIcon("assets/images/home_screen/category/heart.png", [
              const Color(0xff0EBE7E),
              const Color(0xff07D9AD),
            ]),
            const SizedBox(width: 10),
            _buildCategoryIcon("assets/images/home_screen/category/eye.png", [
              const Color(0xffFE7F44),
              const Color(0xffFFCF68),
            ]),
            const SizedBox(width: 10),
            _buildCategoryIcon("assets/images/home_screen/category/ear.png", [
              const Color(0xffFF484C),
              const Color(0xffFF6C60),
            ]),
            const SizedBox(width: 10),
            _buildCategoryIcon("assets/images/home_screen/category/teeth.png", [
              const Color(0xff2753F3),
              const Color(0xff765AFC),
            ]),
            const SizedBox(width: 10),
            _buildCategoryIcon("assets/images/home_screen/category/heart.png", [
              const Color(0xff0EBE7E),
              const Color(0xff07D9AD),
            ]),
            const SizedBox(width: 10),
            _buildCategoryIcon("assets/images/home_screen/category/eye.png", [
              const Color(0xffFE7F44),
              const Color(0xffFFCF68),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String asset, List<Color> color) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.15,
      width: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: color,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      child: Center(
        child: Image.asset(
          asset,
          width: MediaQuery.of(context).size.width * 0.07,
          height: MediaQuery.of(context).size.width * 0.07,
        ),
      ),
    );
  }

  Widget _buildPopularDoctors() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeadline(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PopularDoctorScreen(),
                ),
              );
            },
            text: "Popular Doctor",
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.025),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDoctorCard(
                  "Dr. Fillerup Grab",
                  "Medicine Specialist",
                  "assets/images/home_screen/popular_doctor/popular_doctor1.jpg",
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                _buildDoctorCard(
                  "Dr. Blessing",
                  "Dentist Specialist",
                  "assets/images/home_screen/popular_doctor/popular_doctor2.jpg",
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                _buildDoctorCard(
                  "Dr. Fillerup Grab",
                  "Medicine Specialist",
                  "assets/images/home_screen/popular_doctor/popular_doctor1.jpg",
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                _buildDoctorCard(
                  "Dr. Blessing",
                  "Medicine Specialist",
                  "assets/images/home_screen/popular_doctor/popular_doctor2.jpg",
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                _buildDoctorCard(
                  "Dr. Fillerup Grab",
                  "Medicine Specialist",
                  "assets/images/home_screen/popular_doctor/popular_doctor1.jpg",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(String name, String specialty, String image) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      width: MediaQuery.of(context).size.width * 0.38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            image,
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Text(
            name,
            style: GoogleFonts.rubik(
              color: const Color(0xff333333),
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            specialty,
            style: GoogleFonts.rubik(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              color: const Color(0xff677294),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          _buildStarRating(4.5),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    double iconSize = MediaQuery.of(context).size.width * 0.035;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          List.generate(
              fullStars,
              (index) => Icon(
                Icons.star,
                color: const Color(0xffF6D060),
                size: iconSize,
              ),
            )
            ..addAll(
              halfStar
                  ? [
                      Icon(
                        Icons.star_half,
                        color: const Color(0xffF6D060),
                        size: iconSize,
                      ),
                    ]
                  : [],
            )
            ..addAll(
              List.generate(
                5 - fullStars - (halfStar ? 1 : 0),
                (index) => Icon(Icons.star, color: Colors.grey, size: iconSize),
              ),
            ),
    );
  }

  Widget _buildFeatureDoctors() {
    List<Map<String, String>> doctors = [
      {
        "name": "Dr. Crick",
        "price": "\$25.00/ hours",
        "image": "featuredoctor1.png",
      },
      {
        "name": "Dr. Strain",
        "price": "\$22.00/ hours",
        "image": "featuredoctor2.png",
      },
      {
        "name": "Dr. Lachinet",
        "price": "\$29.00/ hours",
        "image": "featuredoctor3.png",
      },
      {
        "name": "Dr. Morgan",
        "price": "\$24.00/ hours",
        "image": "featuredoctor2.png",
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeadline(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindDoctorsScreen(),
                ),
              );
            },
            text: "Feature Doctor",
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.26,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(doctors.length, (index) {
                  var doctor = doctors[index];
                  return _buildFeatureDoctorCard(
                    doctor["name"]!,
                    doctor["price"]!,
                    doctor["image"]!,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureDoctorCard(
    String name,
    String pricing,
    String imagePath,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.025),
      padding: EdgeInsets.all(screenWidth * 0.025),
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: screenWidth * 0.0025,
            blurRadius: screenWidth * 0.012,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: screenWidth * 0.12,
            backgroundImage: AssetImage(
              "assets/images/home_screen/feature_doctor/$imagePath",
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
              color: const Color(0xff333333),
            ),
          ),
          Text(
            pricing,
            style: GoogleFonts.rubik(
              fontSize: screenWidth * 0.03,
              color: const Color(0xff0EBE7E),
            ),
          ),
        ],
      ),
    );
  }
}
