import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Container(
      padding: const .symmetric(horizontal: 15, vertical: 60),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: .only(
          bottomLeft: .circular(30),
          bottomRight: .circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Obx(
                () => Text(
                  "Hi ${homeController.userName.value}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: .w300,
                  ),
                ),
              ),

              Text(
                "Find Your Doctor",
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: AppColors.white),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, color: AppColors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
