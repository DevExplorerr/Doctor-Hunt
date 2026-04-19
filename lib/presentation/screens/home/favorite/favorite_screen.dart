// ignore_for_file: deprecated_member_use

import 'package:doctor_hunt/presentation/screens/doctors/find_doctors_screen.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:doctor_hunt/presentation/widgets/header/top_section.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Shouey',
      'specialty': 'Specialist Cardiology',
      'image': 'assets/images/favorite_screen/favorite_doctor1.png',
      'isFavorite': false,
    },
    {
      'name': 'Dr. Christenfeld N',
      'specialty': 'Specialist Cancer',
      'image': 'assets/images/favorite_screen/favorite_doctor2.png',
      'isFavorite': true,
    },
    {
      'name': 'Dr. Shouey',
      'specialty': 'Specialist Medicine',
      'image': 'assets/images/favorite_screen/favorite_doctor3.png',
      'isFavorite': true,
    },
    {
      'name': 'Dr. Shouey',
      'specialty': 'Specialist Dentist',
      'image': 'assets/images/favorite_screen/favorite_doctor4.png',
      'isFavorite': false,
    },
    {
      'name': 'Dr. Christenfeld N',
      'specialty': 'Specialist Cancer',
      'image': 'assets/images/favorite_screen/favorite_doctor2.png',
      'isFavorite': true,
    },
    {
      'name': 'Dr. Christenfeld N',
      'specialty': 'Specialist Cancer',
      'image': 'assets/images/favorite_screen/favorite_doctor2.png',
      'isFavorite': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF).withOpacity(0.5),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/favorite_screen/favorite_screen_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopSection(text: 'Favorite Doctors'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomSearchBar(hintText: 'Dentist'),
                      SizedBox(height: screenHeight * 0.02),
                      _buildFavoriteDoctorGrid(screenWidth),
                      SizedBox(height: screenHeight * 0.03),
                      _buildFeatureDoctors(screenWidth, screenHeight),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteDoctorGrid(double screenWidth) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 3 : 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: screenWidth * 0.03,
        mainAxisSpacing: screenWidth * 0.03,
      ),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(
          doctor: doctors[index],
          onFavoriteToggle: () {
            setState(() {
              doctors[index]['isFavorite'] = !doctors[index]['isFavorite'];
            });
          },
        );
      },
    );
  }

  Widget _buildDoctorCard({
    required Map<String, dynamic> doctor,
    required VoidCallback onFavoriteToggle,
  }) {
    return Card(
      elevation: 0.5,
      color: const Color(0xffFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(doctor['image']),
                ),
                Positioned(
                  top: -10,
                  right: -10,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xffFFFFFF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        doctor['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                        color: doctor['isFavorite'] ? const Color(0xffFB0000) : const Color(0xff677294),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              doctor['name'],
              style: GoogleFonts.rubik(fontSize: 15,  fontWeight: FontWeight.w500,color: const Color(0xff333333)),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              doctor['specialty'],
              style: GoogleFonts.rubik(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff0EBE7F)),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureDoctors(double screenWidth, double screenHeight) {
    List<Map<String, String>> doctors = [
      {
        "name": "Dr. Crick",
        "price": "\$25.00/ hour",
        "image": "featuredoctor1.png"
      },
      {
        "name": "Dr. Strain",
        "price": "\$22.00/ hour",
        "image": "featuredoctor2.png"
      },
      {
        "name": "Dr. Lachinet",
        "price": "\$29.00/ hour",
        "image": "featuredoctor3.png"
      },
      {
        "name": "Dr. Morgan",
        "price": "\$24.00/ hour",
        "image": "featuredoctor2.png"
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeadline(
            onlyText: false,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FindDoctorsScreen()),
              );
            },
            text: "Feature Doctor",
          ),
          SizedBox(height: screenHeight * 0.02),
          SizedBox(
            height: screenHeight * 0.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                var doctor = doctors[index];
                return _buildFeatureDoctorCard(
                  doctor["name"]!,
                  doctor["price"]!,
                  doctor["image"]!,
                  screenWidth,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureDoctorCard(
      String name, String pricing, String imagePath, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.03),
      padding: EdgeInsets.all(screenWidth * 0.03),
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: screenWidth * 0.1,
            backgroundImage: AssetImage("assets/images/home_screen/feature_doctor/$imagePath"),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w500,
              color: const Color(0xff333333),
            ),
          ),
          Text(
            pricing,
            style: GoogleFonts.rubik(
              fontSize: screenWidth * 0.025,
              fontWeight: FontWeight.w300,
              color: const Color(0xff0EBE7E),
            ),
          ),
        ],
      ),
    );
  }
}