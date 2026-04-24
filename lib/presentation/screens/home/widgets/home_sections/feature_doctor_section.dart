import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_cards/feature_doctor_card.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_sections/home_skeleton.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeatureDoctorSection extends StatelessWidget {
  final HomeController controller;
  const FeatureDoctorSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const .symmetric(horizontal: 15.0),
          child: CustomHeadline(
            onlyText: false,
            text: "Feature Doctors",
            onPressed: () {
              Get.toNamed(
                '/all-doctors',
                arguments: {'type': 'feature', 'title': 'Featured'},
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView.builder(
                scrollDirection: .horizontal,
                padding: const .symmetric(horizontal: 15),
                itemCount: 5,
                itemBuilder: (context, index) => const FeatureDoctorSkeleton(),
              );
            }

            return ListView.builder(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 15),
              clipBehavior: .none,
              itemCount: controller.featureDoctors.length,
              itemBuilder: (context, index) {
                final doctor = controller.featureDoctors[index];
                return FeatureDoctorCard(doctor: doctor);
              },
            );
          }),
        ),
      ],
    );
  }
}
