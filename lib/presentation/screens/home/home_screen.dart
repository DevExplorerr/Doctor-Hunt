import 'package:doctor_hunt/controllers/layout/home_controller.dart';
import 'package:doctor_hunt/presentation/screens/appointments/my_appointments_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/profile/profile_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_content.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/medicine_orders_screen.dart';
import 'package:doctor_hunt/presentation/widgets/navigation/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    final List<Widget> pages = [
      HomeContent(controller: controller),
      const MyAppointmentsScreen(),
      const MedicineOrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: controller.pageController,
        physics: const ScrollPhysics(),
        dragStartBehavior: .down,
        onPageChanged: (index) {
          controller.selectedIndex.value = index;
        },
        children: pages,
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          selectedIndex: controller.selectedIndex.value,
          onItemTapped: controller.changeTabIndex,
        ),
      ),
    );
  }
}
