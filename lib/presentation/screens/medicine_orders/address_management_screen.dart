import 'package:doctor_hunt/controllers/pharmacy/checkout_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/add_address_screen.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckoutController controller = Get.put(CheckoutController());
    final textTheme = Theme.of(context).textTheme;

    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "My Addresses", showCart: false),
          Expanded(
            child: Obx(() {
              if (controller.savedAddresses.isEmpty) {
                return Center(
                  child: Text(
                    "No addresses saved yet.",
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const .all(20),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.savedAddresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final addr = controller.savedAddresses[index];

                  return Container(
                    padding: const .all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: .all(
                        color: AppColors.textSecondary.withValues(alpha: 0.2),
                      ),
                      borderRadius: .circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      addr.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: .w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.editAddress(addr),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: AppColors.icon,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () => controller.deleteAddress(addr),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: AppColors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(addr.address, style: textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text(
                          addr.phoneNumber,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: .w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          SafeArea(
            child: Padding(
              padding: const .symmetric(vertical: 30, horizontal: 20),
              child: CustomButton(
                text: "Add New Address",
                fontSize: 18,
                onTap: () {
                  controller.addressBeingEdited = null;

                  controller.nameController.clear();
                  controller.addressController.clear();
                  controller.phoneController.clear();

                  Get.to(() => const AddAddressScreen());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
