import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      child: Column(
        children: [
          Padding(
            padding: const .only(top: 50, left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.icon),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Favorite Doctors",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
