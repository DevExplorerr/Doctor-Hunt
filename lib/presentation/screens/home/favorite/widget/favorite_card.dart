import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/doctor_model.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/favorite_button.dart';
import 'package:flutter/material.dart';

class FavoriteCard extends StatelessWidget {
  final DoctorModel doctor;

  const FavoriteCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const .only(bottom: 15),
      padding: const .all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: .circle,
              border: .all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: doctor.image,
                fit: .cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.grey.withValues(alpha: 0.2)),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, color: AppColors.icon),
              ),
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 5),
                Text(
                  doctor.name,
                  style: textTheme.titleMedium?.copyWith(fontWeight: .w700),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          FavoriteButton(doctor: doctor),
        ],
      ),
    );
  }
}
