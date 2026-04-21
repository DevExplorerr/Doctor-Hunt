import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_cards/live_doctor_card.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_sections/home_skeleton.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveDoctorSection extends StatelessWidget {
  final HomeController controller;
  const LiveDoctorSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Padding(
          padding: .only(left: 15),
          child: CustomHeadline(text: "Live Doctors", onlyText: true),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView.builder(
                scrollDirection: .horizontal,
                padding: const .symmetric(horizontal: 15),
                itemCount: 5,
                itemBuilder: (context, index) => const LiveDoctorSkeleton(),
              );
            }

            return ListView.builder(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 15),
              itemCount: controller.liveDoctors.length,
              itemBuilder: (context, index) {
                final doctor = controller.liveDoctors[index];
                return LiveDoctorCard(doctor: doctor);
              },
            );
          }),
        ),
      ],
    );
  }
}
