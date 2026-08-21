import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/controllers/checkout_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/address_model.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/add_address_screen.dart';
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
                        Obx(() {
                          if (controller.savedAddresses.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "No addresses saved yet.",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }

                          return SizedBox(
                            height: 130,
                            child: RadioGroup<AddressModel>(
                              groupValue: controller.selectedAddress.value,
                              onChanged: (AddressModel? value) {
                                if (value != null) {
                                  controller.selectAddress(value);
                                }
                              },
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.savedAddresses.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final addr = controller.savedAddresses[index];
                                  final isSelected =
                                      controller.selectedAddress.value == addr;
                                  return GestureDetector(
                                    onTap: () => controller.selectAddress(addr),
                                    child: Container(
                                      width: 280,
                                      padding: const .all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary.withValues(
                                                alpha: 0.1,
                                              )
                                            : AppColors.white,
                                        border: .all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.grey.withValues(
                                                  alpha: 0.2,
                                                ),
                                          width: isSelected ? 1.5 : 1.0,
                                        ),
                                        borderRadius: .circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: .spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child: Radio<AddressModel>(
                                                      value: addr,
                                                      activeColor:
                                                          AppColors.primary,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Deliver Here",
                                                    style: textTheme.bodySmall
                                                        ?.copyWith(
                                                          fontWeight: isSelected
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                                    .normal,
                                                          color: isSelected
                                                              ? AppColors
                                                                    .primary
                                                              : AppColors
                                                                    .textSecondary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => controller
                                                        .editAddress(addr),
                                                    child: const Icon(
                                                      Icons.edit,
                                                      size: 18,
                                                      color: AppColors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () => controller
                                                        .deleteAddress(addr),
                                                    child: const Icon(
                                                      Icons.delete_outline,
                                                      size: 18,
                                                      color: AppColors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            addr.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.bodyMedium
                                                ?.copyWith(fontWeight: .w700),
                                          ),
                                          Text(
                                            addr.address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.bodyMedium
                                                ?.copyWith(fontWeight: .w700),
                                          ),
                                          const Spacer(),
                                          Text(
                                            addr.phoneNumber,
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: .infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              controller.addressBeingEdited = null;

                              controller.nameController.clear();
                              controller.addressController.clear();
                              controller.phoneController.clear();

                              Get.to(() => const AddAddressScreen());
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add New Address"),
                            style: OutlinedButton.styleFrom(
                              padding: const .symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(12),
                              ),
                            ),
                          ),
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
