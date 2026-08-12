import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MedicineHorizontalCard extends StatelessWidget {
  final String id;
  final String name;
  final String quantity;
  final String image;
  final double price;
  final VoidCallback onTap;

  const MedicineHorizontalCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.image,
    required this.price,
    required this.onTap,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(16),
        child: Container(
          width: 160,
          height: 260,
          padding: const .all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: .circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  child: Hero(
                    tag: 'medicine_$id',
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: .contain,
                      placeholder: (_, __) => Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.medication,
                        size: 40,
                        color: AppColors.icon,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                name,
                maxLines: 2,
                overflow: .ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: .w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                quantity,
                maxLines: 1,
                overflow: .ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "\$${price.toStringAsFixed(2)}",
                      overflow: .ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: .w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
