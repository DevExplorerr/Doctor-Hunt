import 'package:doctor_hunt/controllers/pharmacy/cart_controller.dart';
import 'package:doctor_hunt/controllers/layout/home_controller.dart';
import 'package:doctor_hunt/controllers/pharmacy/medicine_orders_controller.dart';
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
    return MainWrapper(
      child: Column(
        children: [
          CustomAppBar(
            title: "Medicine Orders",
            onBackPressed: () {
              if (Navigator.of(context).canPop()) {
                Get.back();
              } else if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().changeTabIndex(0);
              }
            },
          ),
          const Expanded(child: MedicineCategoryGrid()),
        ],
      ),
    );
  }
}
