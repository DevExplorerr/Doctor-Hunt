import 'package:doctor_hunt/presentation/screens/medicine_orders/address_management_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/cart/cart_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/coming_soon.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/pharmacy_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/empty_orders_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/prescription_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineOrdersController extends GetxController {
  var hasOrders = true.obs;

  final List<Map<String, dynamic>> categories = [
    {"title": "Pharmacy", "icon": Icons.local_pharmacy},
    {"title": "Cart", "icon": Icons.shopping_cart},
    {"title": "Addresses", "icon": Icons.location_on},
    {"title": "Prescription", "icon": Icons.medication},
    {"title": "Order status", "icon": Icons.shopping_cart_checkout},
    {"title": "Order delivery", "icon": Icons.local_shipping_outlined},
    {"title": "Payments & Refunds", "icon": Icons.payment_outlined},
    {"title": "Order returns", "icon": Icons.assignment_return_outlined},
  ];

  void handleCategoryTap(String title) {
    final orderDependentCategories = [
      "Order status",
      "Order delivery",
      "Order returns",
      "Payments & Refunds",
    ];

    if (orderDependentCategories.contains(title)) {
      if (hasOrders.value) {
        Get.to(() => ComingSoonScreen(title: title));
      } else {
        Get.to(() => EmptyOrdersScreen(title: title));
      }
    } else if (title == "Pharmacy") {
      Get.to(() => const PharmacyScreen());
    } else if (title == "Prescription") {
      Get.to(() => const PrescriptionScreen());
    } else if (title == "Cart") {
      Get.to(() => const CartScreen());
    } else if (title == "Addresses") {
      Get.to(() => const AddressManagementScreen());
    } else {
      Get.snackbar("Routing", "Going to the $title screen.");
    }
  }
}
