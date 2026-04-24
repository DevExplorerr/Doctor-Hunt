import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_sections/category_section.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_sections/feature_doctor_section.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_sections/live_doctor_section.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_app_bar.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_sections/popular_doctor_section.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    hintText: "Search...",
                    readOnly: true,
                    onTap: () {
                      Get.toNamed(
                        '/all-doctors',
                        arguments: {'title': 'Search', 'focusSearch': true},
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const .symmetric(vertical: 40),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 15),
                  LiveDoctorSection(controller: controller),
                  const SizedBox(height: 30),
                  const CategorySection(),
                  const SizedBox(height: 15),
                  PopularDoctorSection(controller: controller),
                  const SizedBox(height: 15),
                  FeatureDoctorSection(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
