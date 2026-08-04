import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/loading/shimmer_loading.dart';
import 'package:flutter/material.dart';

class SearchMedicineShimmer extends StatelessWidget {
  const SearchMedicineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.65,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: ShimmerWidget.rectangular(height: 100, width: 120),
              ),
              const SizedBox(height: 15),
              const ShimmerWidget.rectangular(height: 16, width: 100),
              const SizedBox(height: 5),
              const ShimmerWidget.rectangular(height: 12, width: 70),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ShimmerWidget.rectangular(height: 20, width: 50),
                  ShimmerWidget.rectangular(
                    height: 32,
                    width: 32,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
