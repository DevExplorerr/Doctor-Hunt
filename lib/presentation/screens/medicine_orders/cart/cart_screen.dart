import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/controllers/pharmacy/cart_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/checkout_screen.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final textTheme = Theme.of(context).textTheme;

    return MainWrapper(
      child: Stack(
        children: [
          Column(
            children: [
              const CustomAppBar(title: "My Cart"),
              Expanded(
                child: Obx(() {
                  if (cartController.cartItems.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: .symmetric(horizontal: 15.0),
                        child: AppEmptyState(
                          title: 'Your cart is empty',
                          description:
                              'Looks like you haven\'t added any medicines to your cart yet.',
                          icon: Icons.shopping_cart_outlined,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const .symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              "${cartController.totalItems} Items",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: .w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                CustomDialog.show(
                                  context,
                                  child: Column(
                                    mainAxisSize: .min,
                                    children: [
                                      Text(
                                        "Clear Cart",
                                        style: textTheme.headlineMedium
                                            ?.copyWith(
                                              color: AppColors.primary,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Are you sure you want to clear the cart?",
                                        textAlign: .center,
                                        style: textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text(
                                                "No",
                                                style: textTheme.bodyLarge,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: CustomButton(
                                              height: 45,
                                              text: "Clear",
                                              onTap: () {
                                                Get.back();
                                                cartController.clearCart();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete_sweep_outlined,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              label: Text(
                                "Clear All",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.red,
                                  fontWeight: .w700,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: .zero,
                                minimumSize: .zero,
                                tapTargetSize: .shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          padding: const .only(
                            left: 15,
                            right: 15,
                            bottom: 120,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: cartController.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartController.cartItems[index];
                            return Dismissible(
                              key: Key(item.name),
                              direction: .endToStart,
                              background: Container(
                                margin: const .only(bottom: 15),
                                padding: const .only(right: 15),
                                alignment: .centerRight,
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: .circular(16),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: AppColors.white,
                                  size: 25,
                                ),
                              ),
                              onDismissed: (direction) {
                                cartController.removeFromCart(item);
                                AppSnackBar.show(
                                  title: "Removed from Cart",
                                  message: "${item.name} removed successfully!",
                                  snackPosition: .BOTTOM,
                                );
                              },
                              child: Container(
                                margin: const .only(bottom: 15),
                                padding: const .all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: .circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      padding: const .all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.05,
                                        ),
                                        borderRadius: .circular(12),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: item.image,
                                        fit: BoxFit.contain,
                                        placeholder: (_, __) =>
                                            LoadingAnimationWidget.threeArchedCircle(
                                              color: AppColors.primary,
                                              size: 20,
                                            ),
                                        errorWidget: (_, __, ___) => const Icon(
                                          Icons.medication,
                                          color: AppColors.icon,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: textTheme.bodyLarge
                                                ?.copyWith(fontWeight: .w700),
                                            maxLines: 1,
                                            overflow: .ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: .spaceBetween,
                                            children: [
                                              Text(
                                                "\$${item.price.toStringAsFixed(2)}",
                                                style: textTheme.bodyLarge
                                                    ?.copyWith(
                                                      color: AppColors.primary,
                                                      fontWeight: .w700,
                                                    ),
                                              ),
                                              Row(
                                                children: [
                                                  _buildSmallControlButton(
                                                    icon: Icons.remove,
                                                    onTap: () => cartController
                                                        .decreaseQuantity(item),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    item.quantityCount
                                                        .toString(),
                                                    style: textTheme.titleSmall
                                                        ?.copyWith(
                                                          fontWeight: .w700,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  _buildSmallControlButton(
                                                    icon: Icons.add,
                                                    onTap: () => cartController
                                                        .increaseQuantity(item),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          Obx(() {
            if (cartController.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  margin: const .only(left: 15, right: 15, bottom: 15),
                  padding: const .symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: .circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "Grand Total",
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: .w700,
                              ),
                            ),
                            Text(
                              "\$${cartController.totalPrice.toStringAsFixed(2)}",
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: .w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          text: "Checkout",
                          borderRadius: 16,
                          onTap: () {
                            Get.to(() => const CheckoutScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSmallControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(6),
        side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(6),
        child: Padding(
          padding: const .all(4),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
      ),
    );
  }
}
