import 'package:doctor_hunt/controllers/profile_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainWrapper(
        child: Column(
          children: [
            const CustomAppBar(title: "Edit Profile"),
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const .symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Personal Information",
                      style: textTheme.titleMedium?.copyWith(fontWeight: .w700),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Update your contact details to keep medical reports accurate.",
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 25),

                    Text(
                      "Full Name",
                      style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.nameFieldController,
                      hintText: "Enter your full name",
                      keyboardType: .name,
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Contact Number",
                      style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.phoneFieldController,
                      hintText: "Enter your contact number",
                      keyboardType: .phone,
                      textInputAction: .done,
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Email Address",
                      style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.emailFieldController,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.secondary.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: .circular(12),
                          borderSide: .none,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const .symmetric(vertical: 40.0, horizontal: 20),
              child: Obx(() {
                return CustomButton(
                  text: "Save Changes",
                  isLoading: controller.isLoading.value,
                  onTap: () async {
                    bool done = await controller.updateProfileDetails();

                    if (done) {
                      Get.back();
                      AppSnackBar.show(
                        title: "Success",
                        message:
                            "Your profile details have been successfully saved",
                      );
                    }
                  },
                  height: 52,
                  borderRadius: 10,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
