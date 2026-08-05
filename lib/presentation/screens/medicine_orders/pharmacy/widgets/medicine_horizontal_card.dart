import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/cart_item.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MedicineHorizontalCard extends StatelessWidget {
  final String name;
  final String quantity;
  final String image;
  final double price;
  final int quantityCount;
  final CartController cartController;

  const MedicineHorizontalCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.image,
    required this.price,
    this.quantityCount = 1,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 180,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.contain,
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

            const SizedBox(height: 15),

            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 5),

            Text(
              quantity,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: textTheme.titleMedium,
                ),
                GestureDetector(
                  onTap: () {
                    cartController.addToCart(
                      CartItem(
                        name: name,
                        price: price,
                        image: image,
                        quantityCount: quantityCount,
                      ),
                    );

                    AppSnackBar.show(
                      title: "Added to Cart",
                      message: "$name added successfully!",
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
