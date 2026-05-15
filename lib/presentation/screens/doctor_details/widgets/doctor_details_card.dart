import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:doctor_hunt/presentation/screens/doctor_details/widgets/star_rating.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DoctorDetailsCard extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorDetailsCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: .infinity,
      padding: const .all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const .all(.circular(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const .all(.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: doctor.image,
                  width: 90,
                  height: 90,
                  fit: .cover,
                  filterQuality: .high,
                  placeholder: (context, url) => Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: AppColors.icon),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            overflow: .ellipsis,
                            maxLines: 1,
                            style: textTheme.titleMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.favorite,
                            color: AppColors.favorite,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      doctor.specialty,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        StarRating(rating: doctor.rating),
                        const Spacer(),
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
                                text:
                                    "${doctor.pricePerHour.toStringAsFixed(2)}/hr",
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(text: "Book Now", height: 40, width: 150, onTap: () {}),
        ],
      ),
    );
  }
}
