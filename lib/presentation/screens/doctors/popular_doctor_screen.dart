import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:doctor_hunt/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularDoctorScreen extends StatelessWidget {
  const PopularDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/popular_screen/popular_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopSection(
                iconButton: const Icon(Icons.search),
                backButton: const Icon(Icons.chevron_left),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeadline(text: "Popular Doctor"),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildDoctorCard(
                              "Dr. Truluck Nik",
                              "Medicine Specialist",
                              "assets/images/popular_screen/popular_doctor1.png",
                            ),
                            _buildDoctorCard(
                              "Dr. Tranquilli",
                              "Pathology Specialist",
                              "assets/images/popular_screen/popular_doctor2.png",
                            ),
                            _buildDoctorCard(
                              "Dr. Truluck Nik",
                              "Medicine Specialist",
                              "assets/images/popular_screen/popular_doctor3.png",
                            ),
                            _buildDoctorCard(
                              "Dr. Tranquilli",
                              "Pathology Specialist",
                              "assets/images/popular_screen/popular_doctor4.png",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Category",
                        style: GoogleFonts.rubik(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff333333),
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: [
                          _buildCategoryCard(
                            "Dr. Pediatrician",
                            "Specialist Cardiologist",
                            2.4,
                            2475,
                            true,
                            "assets/images/popular_screen/popular_category_doctor1.png",
                          ),
                          _buildCategoryCard(
                            "Dr. Mistry Brick",
                            "Specialist Dentist",
                            2.8,
                            2893,
                            false,
                            "assets/images/popular_screen/popular_category_doctor2.png",
                          ),
                          _buildCategoryCard(
                            "Dr. Ether Wall",
                            "Specialist Cancer",
                            2.7,
                            2754,
                            true,
                            "assets/images/popular_screen/popular_category_doctor3.png",
                          ),
                          _buildCategoryCard(
                            "Dr. Pediatrician",
                            "Specialist Cancer",
                            2.7,
                            2754,
                            true,
                            "assets/images/popular_screen/popular_category_doctor4.png",
                          ),
                          _buildCategoryCard(
                            "Dr. Mistry Brick",
                            "Specialist cardiologist",
                            2.7,
                            2754,
                            true,
                            "assets/images/popular_screen/popular_category_doctor5.png",
                          ),
                        ],
                      ),
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

  Widget _buildDoctorCard(String name, String specialty, String imagePath) {
    return Container(
      width: 136,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xffFFFFFF),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath,
              height: 131,
              width: 136,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF677294),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 3),
                _buildStarRating(4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String name,
    String specialty,
    double rating,
    int views,
    bool isFavorite,
    String imagePath,
  ) {
    return Card(
      elevation: 0.5,
      color: const Color(0xffFFFFFF),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          name,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: const Color(0xff333333),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              specialty,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: const Color(0xff677294),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFF6D060), size: 16),
                const SizedBox(width: 4),
                Text(
                  "$rating",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xff333333),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "($views views)",
                  style: GoogleFonts.rubik(
                    color: const Color(0xff677294),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}

Widget _buildStarRating(double rating) {
  int fullStars = rating.floor();
  bool halfStar = (rating - fullStars) >= 0.5;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:
        List.generate(
            fullStars,
            (index) =>
                const Icon(Icons.star, color: Color(0xffF6D060), size: 13),
          )
          ..addAll(
            halfStar
                ? [
                    const Icon(
                      Icons.star_half,
                      color: Color(0xffF6D060),
                      size: 13,
                    ),
                  ]
                : [],
          )
          ..addAll(
            List.generate(
              5 - fullStars - (halfStar ? 1 : 0),
              (index) => const Icon(Icons.star, color: Colors.grey, size: 13),
            ),
          ),
  );
}
