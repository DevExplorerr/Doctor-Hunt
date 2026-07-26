import 'package:doctor_hunt/presentation/screens/home/medical_records/pharmacy_screen.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyOrdersView extends StatelessWidget {
  const EmptyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const AppEmptyState(
            title: "No orders placed yet",
            description: "Place your first order now",
            icon: Icons.assignment_outlined,
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: "Order medicines",
            onTap: () {
              Get.to(const PharmacyScreen());
            },
          ),
        ],
      ),
    );
  }
}
