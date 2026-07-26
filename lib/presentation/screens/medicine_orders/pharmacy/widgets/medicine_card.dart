import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/cart_item.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final String name;
  final String quantity;
  final String image;
  final double price;
  final int quantityCount;
  final CartController cartController;

  const MedicineCard({
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
    return Container(
      width: 160,
      padding: const .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        color: AppColors.white,
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
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Center(
            child: Image.asset(image, height: 100, width: 120, fit: .contain),
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: textTheme.bodyLarge?.copyWith(fontWeight: .w600),
            maxLines: 1,
            overflow: .ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            quantity,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: .ellipsis,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: .spaceBetween,
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
                  padding: const .all(5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: .circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
