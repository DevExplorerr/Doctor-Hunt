import 'dart:ui';
import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/cart_item.dart';
import 'package:doctor_hunt/data/models/pharmacy_model.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineDetailsScreen extends StatelessWidget {
  final PharmacyModel medicine;
  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final RxInt selectedQuantity = 1.obs;
    final CartController controller = Get.find<CartController>();
    return MainWrapper(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const .only(bottom: 120),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const CustomAppBar(title: "Medicine Details"),
                Padding(
                  padding: const .symmetric(horizontal: 15.0),
                  child: SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: .circular(24),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 20,
                              sigmaY: 20,
                            ),
                            child: Image.network(
                              medicine.image,
                              fit: .cover,
                              width: .infinity,
                              height: .infinity,
                              filterQuality: .medium,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(24),
                            gradient: LinearGradient(
                              begin: .topCenter,
                              end: .bottomCenter,
                              colors: [
                                AppColors.white.withValues(alpha: 0.1),
                                AppColors.black.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: 'medicine_${medicine.id}',
                            child: Image.network(
                              medicine.image,
                              height: 220,
                              fit: .contain,
                              filterQuality: .high,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const .all(20),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        crossAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: Text(
                              medicine.name,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: .w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "\$${medicine.price.toStringAsFixed(2)}",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: .w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        medicine.quantity,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            "Quantity",
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: .w600,
                            ),
                          ),
                          const Spacer(),
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (selectedQuantity.value > 1) {
                                selectedQuantity.value--;
                              }
                            },
                          ),
                          const SizedBox(width: 15),
                          Obx(
                            () => Text(
                              selectedQuantity.value.toString(),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: .w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onTap: () => selectedQuantity.value++,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 20),
                      Text(
                        "Description",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        medicine.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: .bottomCenter,
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
                            "Total Price",
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Obx(
                            () => Text(
                              "\$${(medicine.price * selectedQuantity.value).toStringAsFixed(2)}",
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: .w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: "Add to Cart",
                        borderRadius: 16,
                        onTap: () {
                          controller.addToCart(
                            CartItem(
                              name: medicine.name,
                              price: medicine.price,
                              image: medicine.image,
                              quantityCount: selectedQuantity.value,
                            ),
                          );
                          Get.back();
                          AppSnackBar.show(
                            title: "Added to Cart",
                            message: "${medicine.name} added successfully!",
                            snackPosition: .BOTTOM,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(8),
        side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(8),
        child: Padding(
          padding: const .all(8.0),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}
