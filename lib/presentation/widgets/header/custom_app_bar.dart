import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/cart/widget/cart_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onReset;
  final bool showReset;
  final bool showCart;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onReset,
    this.showReset = false,
    this.showCart = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackPressed ?? () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: AppColors.icon),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (showReset) ...[
            GestureDetector(
              onTap: onReset,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: AppColors.red),
              ),
            ),
            if (showCart) const SizedBox(width: 10),
          ],
          if (showCart) const CartIconButton(),
        ],
      ),
    );
  }
}
