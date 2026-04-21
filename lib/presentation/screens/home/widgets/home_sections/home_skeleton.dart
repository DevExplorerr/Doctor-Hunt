import 'package:doctor_hunt/presentation/widgets/loading/shimmer_loading.dart';
import 'package:flutter/material.dart';

class LiveDoctorSkeleton extends StatelessWidget {
  const LiveDoctorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .only(right: 12),
      child: const ShimmerWidget.rectangular(
        height: 150,
        width: 100,
        shapeBorder: RoundedRectangleBorder(borderRadius: .all(.circular(12))),
      ),
    );
  }
}

class PopularDoctorSkeleton extends StatelessWidget {
  const PopularDoctorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const .only(right: 16),
      child: const ShimmerWidget.rectangular(
        height: 240,
        shapeBorder: RoundedRectangleBorder(borderRadius: .all(.circular(12))),
      ),
    );
  }
}

class FeatureDoctorSkeleton extends StatelessWidget {
  const FeatureDoctorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const .only(right: 16),
      child: const ShimmerWidget.rectangular(
        height: 180,
        shapeBorder: RoundedRectangleBorder(borderRadius: .all(.circular(12))),
      ),
    );
  }
}
