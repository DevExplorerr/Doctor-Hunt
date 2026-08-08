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

    return Container(
      width: 160,
      height: 260, // Fixed height ensures uniform alignment in horizontal lists
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            quantity,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(), // Pushes the price and button to the very bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "\$${price.toStringAsFixed(2)}",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, size: 20, color: AppColors.white),
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
