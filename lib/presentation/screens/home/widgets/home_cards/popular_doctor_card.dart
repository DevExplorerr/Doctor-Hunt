import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PopularDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const PopularDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 170,
      margin: const .only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const .vertical(top: .circular(12)),
                child: CachedNetworkImage(
                  imageUrl: doctor.image,
                  width: .infinity,
                  height: 130,
                  fit: .cover,
                  filterQuality: .high,
                  placeholder: (context, url) => Center(
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: AppColors.icon),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.5),
                    shape: .circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite,
                      size: 18,
                      color: AppColors.favorite,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                doctor.name,
                style: textTheme.titleMedium?.copyWith(fontWeight: .w600),
                maxLines: 1,
                overflow: .ellipsis,
              ),
              Text(doctor.specialty, style: textTheme.bodySmall),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: .center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < doctor.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: AppColors.review,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
