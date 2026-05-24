import 'package:doctor_hunt/controllers/favorite_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteButton extends StatelessWidget {
  final DoctorModel doctor;
  final double size;
  final EdgeInsetsGeometry padding;

  const FavoriteButton({
    super.key,
    required this.doctor,
    this.size = 20,
    this.padding = .zero,
  });

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoriteController>();

    return Obx(() {
      final isFav = favController.isFavorite(doctor.id);
      return GestureDetector(
        onTap: () => favController.toggleFavorite(doctor),
        child: Padding(
          padding: padding,
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? AppColors.primary : AppColors.icon,
            size: size,
          ),
        ),
      );
    });
  }
}
