import 'package:doctor_hunt/presentation/screens/home/appointments/my_appointments_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/pharmacy/medical_records_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/pharmacy/pharmacy_screen.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class AppMenuController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();

  var activeMenuItem = "Home".obs;
  DateTime? _lastBackPressTime;

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  void setMenuItem(String itemName) {
    activeMenuItem.value = itemName;
    toggleDrawer();
  }

  void handleBackGesture() {
    if (zoomDrawerController.isOpen?.call() ?? false) {
      zoomDrawerController.close?.call();
      return;
    }

    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      AppSnackBar.show(
        title: "Exit App",
        message: "Swipe back again to close the app",
        snackPosition: .BOTTOM,
      );
    } else {
      SystemNavigator.pop();
    }
  }

  void handleMenuRouting(String title) {
    setMenuItem(title);

    Future.delayed(const Duration(milliseconds: 250), () {
      switch (title) {
        case "My Appointments":
          Get.to(() => const MyAppointmentsScreen());
          break;
        case "Medical Records":
          Get.to(() => const MedicalRecordsScreen());
          break;
        case "Payments":
          // Get.to(() => const PaymentsScreen());
          break;
        case "Medicine Orders":
          Get.to(() => const PharmacyScreen());
          break;
        case "Privacy & Policy":
          // Get.to(() => const PrivacyPolicyScreen());
          break;
        case "Settings":
          // Get.to(() => const SettingsScreen());
          break;
        default:
          debugPrint("⚠️ No route defined for: $title");
      }
    });
  }
}
