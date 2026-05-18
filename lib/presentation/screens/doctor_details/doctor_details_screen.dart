import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/presentation/screens/doctor_details/widgets/doctor_stats_row.dart';
import 'package:doctor_hunt/presentation/screens/doctor_details/widgets/services_section.dart';
import 'package:doctor_hunt/presentation/widgets/card/doctor_details_card.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final doctor = controller.selectedDoctor.value!;

    return MainWrapper(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const CustomAppBar(title: "Doctor Details"),
            DoctorDetailsCard(
              doctor: doctor,
              buttonText: "Book Now",
              onTap: () => controller.startBooking(doctor),
            ),
            const SizedBox(height: 25),
            DoctorStatsRow(
              running: doctor.running,
              experience: doctor.experience,
              patients: doctor.patients,
            ),
            const SizedBox(height: 25),
            ServicesSection(services: doctor.services),
          ],
        ),
      ),
    );
  }
}
