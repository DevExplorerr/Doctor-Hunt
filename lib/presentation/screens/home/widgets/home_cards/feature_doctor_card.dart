import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FeatureDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const FeatureDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const .only(right: 12),
      padding: const .all(10),
      width: 120,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              const Icon(
                Icons.favorite_border,
                size: 18,
                color: AppColors.icon,
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.review, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    doctor.rating.toString(),
                    style: textTheme.bodySmall?.copyWith(fontWeight: .w700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: .circular(50),
            child: CachedNetworkImage(
              imageUrl: doctor.image,
              width: 75,
              height: 75,
              fit: .cover,
              filterQuality: .high,
              placeholder: (context, url) => Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error, color: AppColors.icon)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            doctor.name,
            textAlign: .center,
            style: textTheme.bodyMedium?.copyWith(fontWeight: .w600),
            maxLines: 1,
            overflow: .ellipsis,
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "\$ ",
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: .w600,
                  ),
                ),
                TextSpan(
                  text: "${doctor.pricePerHour.toStringAsFixed(2)}/hours",
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
