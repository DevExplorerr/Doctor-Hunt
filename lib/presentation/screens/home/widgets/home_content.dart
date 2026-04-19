import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatelessWidget {
  final HomeController controller;
  const HomeContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: .none,
              alignment: .center,
              children: [
                const HomeAppBar(),
                Positioned(
                  bottom: -25,
                  left: 20,
                  right: 20,
                  child: CustomSearchBar(
                    controller: controller.searchController,
                    hintText: "Search...",
                  ),
                ),
              ],
            ),

            Padding(
              padding: const .only(top: 40.0, right: 15, left: 15),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 15),
                  _buildLiveDoctors(context),
                  const SizedBox(height: 15),
                  _buildCategories(context),
                  const SizedBox(height: 15),
                  _buildPopularDoctors(context),
                  const SizedBox(height: 15),
                  _buildFeatureDoctors(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LIVE DOCTORS ---
  Widget _buildLiveDoctors(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomHeadline(text: "Live Doctors", onlyText: true),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.liveDoctors.length,
              itemBuilder: (context, index) {
                final doctor = controller.liveDoctors[index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(doctor.image), // FETCH FROM NETWORK
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xffFA002F),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- CATEGORIES (Static) ---
  Widget _buildCategories(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryIcon("assets/images/home_screen/category/teeth.png", [
            const Color(0xff2753F3),
            const Color(0xff765AFC),
          ], context),
          const SizedBox(width: 15),
          _buildCategoryIcon("assets/images/home_screen/category/heart.png", [
            const Color(0xff0EBE7E),
            const Color(0xff07D9AD),
          ], context),
          const SizedBox(width: 15),
          _buildCategoryIcon("assets/images/home_screen/category/eye.png", [
            const Color(0xffFE7F44),
            const Color(0xffFFCF68),
          ], context),
          const SizedBox(width: 15),
          _buildCategoryIcon("assets/images/home_screen/category/ear.png", [
            const Color(0xffFF484C),
            const Color(0xffFF6C60),
          ], context),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(
    String asset,
    List<Color> colors,
    BuildContext context,
  ) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Image.asset(asset, width: 30)),
    );
  }

  // --- POPULAR DOCTORS ---
  Widget _buildPopularDoctors(BuildContext context) {
    return Column(
      children: [
        CustomHeadline(
          onlyText: false,
          text: "Popular Doctor",
          onPressed: () => controller.viewAll('popular', 'Popular Doctors'),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 240,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.popularDoctors.length,
              itemBuilder: (context, index) =>
                  _buildDoctorCard(context, controller.popularDoctors[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doctor) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              doctor.image,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  doctor.name,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                ),
                Text(
                  doctor.specialty,
                  style: GoogleFonts.rubik(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 5),
                _buildStarRating(doctor.rating),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: const Color(0xffF6D060),
          size: 14,
        ),
      ),
    );
  }

  // --- FEATURE DOCTORS ---
  Widget _buildFeatureDoctors(BuildContext context) {
    return Column(
      children: [
        CustomHeadline(
          onlyText: false,
          text: "Feature Doctor",
          onPressed: () => controller.viewAll('feature', 'Feature Doctors'),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.featureDoctors.length,
              itemBuilder: (context, index) {
                final doctor = controller.featureDoctors[index];
                return _buildFeatureDoctorCard(doctor, context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureDoctorCard(DoctorModel doctor, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      width: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 35, backgroundImage: NetworkImage(doctor.image)),
          const SizedBox(height: 8),
          Text(
            doctor.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          Text(
            "\$${doctor.pricePerHour}",
            style: const TextStyle(color: Color(0xff0EBE7E), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
