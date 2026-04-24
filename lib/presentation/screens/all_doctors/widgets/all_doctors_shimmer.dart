import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/loading/shimmer_loading.dart';
import 'package:flutter/material.dart';

class AllDoctorsShimmer extends StatelessWidget {
  const AllDoctorsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const .all(20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const .only(bottom: 15),
          padding: const .all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: .circular(12),
          ),
          child: const Column(
            children: [
              Row(
                children: [
                  ShimmerWidget.rectangular(height: 90, width: 90),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        ShimmerWidget.rectangular(height: 15, width: 120),
                        SizedBox(height: 8),
                        ShimmerWidget.rectangular(height: 12, width: 80),
                        SizedBox(height: 12),
                        ShimmerWidget.rectangular(height: 12, width: 40),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 25),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  ShimmerWidget.rectangular(height: 20, width: 100),
                  ShimmerWidget.rectangular(height: 35, width: 80),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
