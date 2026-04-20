import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LiveDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const LiveDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .only(right: 12),
      width: 100,
      child: ClipRRect(
        borderRadius: .circular(10),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: doctor.image,
              fit: .cover,
              width: 100,
              height: 150,
              filterQuality: .high,
              colorBlendMode: .darken,
              placeholder: (context, url) => Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error, color: AppColors.icon)),
            ),
            Align(
              alignment: .topRight,
              child: Container(
                margin: const .all(6),
                padding: const .symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: .circular(4),
                ),
                child: Text(
                  "LIVE",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: .w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
