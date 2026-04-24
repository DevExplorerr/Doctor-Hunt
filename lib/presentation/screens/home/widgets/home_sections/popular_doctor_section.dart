import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_cards/popular_doctor_card.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_sections/home_skeleton.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularDoctorSection extends StatelessWidget {
  final HomeController controller;
  const PopularDoctorSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const .symmetric(horizontal: 15.0),
          child: CustomHeadline(
            text: "Popular Doctors",
            onlyText: false,
            onPressed: () {
              Get.toNamed(
                '/all-doctors',
                arguments: {'type': 'popular', 'title': "Popular"},
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView.builder(
                scrollDirection: .horizontal,
                padding: const .symmetric(horizontal: 15),
                itemCount: 4,
                itemBuilder: (context, index) => const PopularDoctorSkeleton(),
              );
            }

            return ListView.builder(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 15),
              clipBehavior: .none,
              itemCount: controller.popularDoctors.length,
              itemBuilder: (context, index) {
                final doctor = controller.popularDoctors[index];
                return PopularDoctorCard(doctor: doctor);
              },
            );
          }),
        ),
      ],
    );
  }
}
