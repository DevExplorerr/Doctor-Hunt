import 'package:doctor_hunt/controllers/booking_controller.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(title: "Doctor Details"),
            // Doctor Profile Header
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    doctor.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Text("${doctor.rating}"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Stats Row (Rating, Exp, Patients)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn("100", "Running"),
                _buildStatColumn("${doctor.experience} yrs", "Experience"),
                _buildStatColumn("700", "Patients"),
              ],
            ),
            const SizedBox(height: 30),

            // Services Section
            Text("Services", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),

            // Mapping services from the model
            // ...doctor.services.map(
            //   (service) => Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 4),
            //     child: Text(
            //       "• $service",
            //       style: const TextStyle(color: Colors.black87),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/select-time'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0EBE7E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
