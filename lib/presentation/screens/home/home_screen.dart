import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/presentation/screens/home/favorite/favorite_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/pharmacy/pharmacy_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/profile/profile_screen.dart';
import 'package:doctor_hunt/presentation/screens/home/widgets/home_content.dart';
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
      const FavoriteScreen(),
      const PharmacyScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
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
