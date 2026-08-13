import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    return Obx(() {
      final itemCount = cartController.cartItems.length;
      return Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: AppColors.icon),
            onPressed: () {
              Get.to(() => const CartScreen());
            },
          ),
          if (itemCount > 0)
            Positioned(
              right: 5,
              top: 2,
              child: Container(
                padding: const .all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: .circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '$itemCount',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: .w700,
                  ),
                  textAlign: .center,
                ),
              ),
            ),
        ],
      );
    });
  }
}
