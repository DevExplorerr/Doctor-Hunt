import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class DoctorListItem extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorListItem({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const .only(bottom: 15, left: 5, right: 5),
      padding: const .symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: AppColors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: doctor.image,
                  width: 90,
                  height: 90,
                  fit: .cover,
                  filterQuality: .medium,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      doctor.name,
                      style: textTheme.titleMedium?.copyWith(fontWeight: .w600),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${doctor.experience} Years Experience",
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.review,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doctor.rating.toString(),
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: .w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.favorite_border,
                  color: AppColors.icon,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Next Available",
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: .w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("10:00 AM tomorrow", style: textTheme.bodySmall),
                ],
              ),
              const Spacer(),
              CustomButton(
                text: "Book Now",
                onTap: () {},
                borderRadius: 8,
                height: 40,
                width: 110,
                fontSize: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
