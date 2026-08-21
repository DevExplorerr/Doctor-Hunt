import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/controllers/medicine_orders_controller.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/widgets/medicine_category_grid.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineOrdersScreen extends StatelessWidget {
  const MedicineOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MedicineOrdersController());
    Get.put(CartController());
    return const MainWrapper(
      child: Column(
        children: [
          CustomAppBar(title: "Medicine Orders"),
          Expanded(child: MedicineCategoryGrid()),
        ],
      ),
    );
  }
}
