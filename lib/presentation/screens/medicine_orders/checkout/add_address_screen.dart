import 'package:doctor_hunt/controllers/checkout_controller.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckoutController controller = Get.find<CheckoutController>();
    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "Add New Address"),
          Expanded(
            child: SingleChildScrollView(
              padding: const .all(15),
              child: Column(
                children: [
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: "Full Name",
                    prefixIcon: Icons.person_outline,
                    keyboardType: .name,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: controller.addressController,
                    hintText: "Full Delivery Address",
                    prefixIcon: Icons.location_on_outlined,
                    keyboardType: .streetAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: controller.phoneController,
                    hintText: "Phone Number",
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: .phone,
                    textInputAction: .done,
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => CustomButton(
                      text: "Save Address",
                      isLoading: controller.isSavingAddress.value,
                      onTap: () async {
                        bool isSaved = await controller.saveNewAddress();
                        if (isSaved) {
                          Get.back();
                          AppSnackBar.show(
                            title: 'Saved',
                            message: 'Address saved successfully!',
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
