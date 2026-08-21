import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/controllers/checkout_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/widget/payment_option_card.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/widget/section_card.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/widget/summary_row.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final CheckoutController controller = Get.put(CheckoutController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainWrapper(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const .only(bottom: 140),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const CustomAppBar(title: "Checkout"),
                  SectionCard(
                    title: "Order Items",
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.03),
                        borderRadius: .circular(12),
                      ),
                      child: ListView.separated(
                        padding: const .all(12),
                        itemCount: controller.cartItems.length,
                        separatorBuilder: (_, __) => const Divider(height: 15),
                        itemBuilder: (context, index) {
                          final item = controller.cartItems[index];
                          return Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: .circular(8),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: item.image,
                                  fit: .contain,
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.medication, size: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${item.quantityCount}x",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "\$${(item.price * item.quantityCount).toStringAsFixed(2)}",
                                style: textTheme.titleSmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: .w700,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SectionCard(
                    title: "Shipping Details",
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        CustomTextField(
                          controller: controller.addressController,
                          hintText: "Full Delivery Address",
                          keyboardType: .streetAddress,
                          prefixIcon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: controller.phoneController,
                          hintText: "Phone Number",
                          keyboardType: .phone,
                          textInputAction: .done,
                          prefixIcon: Icons.phone_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SectionCard(
                    title: "Payment Method",
                    child: Column(
                      children: [
                        PaymentOptionCard(
                          title: "Cash on Delivery (COD)",
                          icon: Icons.money,
                          isActive: true,
                          isSelected: true,
                        ),
                        SizedBox(height: 10),
                        PaymentOptionCard(
                          title: "Credit/Debit Card",
                          icon: Icons.money,
                          isActive: false,
                          isSelected: false,
                        ),
                        SizedBox(height: 10),
                        PaymentOptionCard(
                          title: "PayPal",
                          icon: Icons.money,
                          isActive: false,
                          isSelected: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const .symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: controller.promoController,
                            hintText: "Promo Code (e.g. SAVE10)",
                            textInputAction: .done,
                            keyboardType: .text,
                            prefixIcon: Icons.local_offer_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Apply",
                          width: 100,
                          onTap: controller.applyPromoCode,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  SectionCard(
                    title: "Order Summary",
                    child: Column(
                      children: [
                        Obx(
                          () => SummaryRow(
                            title: "Subtotal",
                            amount: controller.subTotal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => SummaryRow(
                            title: "Tax (5%)",
                            amount: controller.taxAmount,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SummaryRow(
                          title: "Shipping Fee",
                          amount: controller.shippingFee,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => SummaryRow(
                            title: "Discount",
                            amount: -controller.discountAmount.value,
                            isDiscount: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  margin: const .all(15),
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
                            Obx(
                              () => Text(
                                "\$${controller.grandTotal.toStringAsFixed(2)}",
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
                          text: "Place Order",
                          borderRadius: 16,
                          isLoading: controller.isProcessing.value,
                          onTap: () {
                            controller.placeOrder();
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
      ),
    );
  }
}
