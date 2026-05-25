import 'package:doctor_hunt/controllers/favorite_controller.dart';
import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/home/favorite/widget/favorite_card.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteController());

    return MainWrapper(
      child: Column(
        children: [
          CustomAppBar(
            title: "Favorite Doctors",
            onBackPressed: () {
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().changeTabIndex(0);
              } else {
                Get.back();
              }
            },
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.favoriteDoctors.isEmpty) {
                return Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.primary,
                    size: 40,
                  ),
                );
              }

              if (controller.favoriteDoctors.isEmpty) {
                return const AppEmptyState(
                  title: "No Favorites Yet",
                  description: "Doctors you favorite will appear here",
                  icon: Icons.favorite_border,
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const .symmetric(horizontal: 20, vertical: 10),
                itemCount: controller.favoriteDoctors.length,
                itemBuilder: (context, index) {
                  return FavoriteCard(
                    doctor: controller.favoriteDoctors[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
