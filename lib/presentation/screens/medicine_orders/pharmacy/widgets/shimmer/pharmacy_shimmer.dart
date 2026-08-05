import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PharmacyShimmer extends StatelessWidget {
  const PharmacyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const SizedBox(height: 25),
        Shimmer.fromColors(
          baseColor: AppColors.grey.withValues(alpha: 0.3),
          highlightColor: AppColors.grey.withValues(alpha: 0.1),
          child: Container(
            width: 150,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: .circular(4),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: .horizontal,
          child: Row(
            children: List.generate(3, (index) {
              return Padding(
                padding: const .only(right: 15.0),
                child: Shimmer.fromColors(
                  baseColor: AppColors.grey.withValues(alpha: 0.3),
                  highlightColor: AppColors.grey.withValues(alpha: 0.1),
                  child: Container(
                    width: 140,
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: .circular(15),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 30),
        Shimmer.fromColors(
          baseColor: AppColors.grey.withValues(alpha: 0.3),
          highlightColor: AppColors.grey.withValues(alpha: 0.1),
          child: Container(
            width: 120,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: .circular(4),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(3, (index) {
              return Padding(
                padding: const .only(right: 15.0),
                child: Shimmer.fromColors(
                  baseColor: AppColors.grey.withValues(alpha: 0.3),
                  highlightColor: AppColors.grey.withValues(alpha: 0.1),
                  child: Container(
                    width: 140,
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: .circular(15),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
