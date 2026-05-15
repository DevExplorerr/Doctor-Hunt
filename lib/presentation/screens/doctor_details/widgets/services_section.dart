import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  final List<String> services;
  const ServicesSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .only(left: 20),
          child: Text(
            "Services",
            style: textTheme.titleMedium?.copyWith(fontWeight: .w700),
          ),
        ),
        const SizedBox(height: 15),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const .only(left: 20, right: 20, bottom: 30),
          itemCount: services.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "${index + 1}.",
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: .w700,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    services[index],
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
