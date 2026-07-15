import 'package:doctor_hunt/controllers/menu_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/home/home_screen.dart';
import 'package:doctor_hunt/presentation/screens/layout/sidebar_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppMenuController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.handleBackGesture();
      },
      child: ZoomDrawer(
        controller: controller.zoomDrawerController,
        menuScreen: const SidebarMenuScreen(),
        mainScreen: const HomeScreen(),
        borderRadius: 30.0,
        showShadow: true,
        angle: 0.0,
        drawerShadowsBackgroundColor: AppColors.white.withValues(alpha: 0.3),
        slideWidth: MediaQuery.of(context).size.width * 0.8,
        menuBackgroundColor: AppColors.secondary,
        mainScreenTapClose: true,
        disableDragGesture: false,
      ),
    );
  }
}
