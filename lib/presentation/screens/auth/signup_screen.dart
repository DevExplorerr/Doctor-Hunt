import 'package:doctor_hunt/controllers/auth_controller/signup_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpController());
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainWrapper(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const .symmetric(horizontal: 25),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: controller.signupFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        const Spacer(),
                        Text(
                          'Join us to start searching',
                          style: textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'You can search doctors, book appointments and find medical aid effortlessly',
                          textAlign: .center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: controller.nameController,
                          hintText: "Full Name",
                          prefixIcon: Icons.person_outline,
                          keyboardType: .name,
                          validator: (val) => (val?.isEmpty ?? true)
                              ? "Name is required"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: controller.emailController,
                          hintText: "Email",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: .emailAddress,
                          validator: (val) => GetUtils.isEmail(val ?? '')
                              ? null
                              : "Enter a valid email",
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: controller.passwordController,
                          hintText: "Password",
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          textInputAction: .done,
                          keyboardType: .visiblePassword,
                          validator: (val) => (val?.length ?? 0) >= 6
                              ? null
                              : "Minimum 6 characters",
                        ),
                        const SizedBox(height: 20),

                        Obx(
                          () => Row(
                            children: [
                              Checkbox(
                                value: controller.isTermsAgreed.value,
                                activeColor: AppColors.primary,
                                onChanged: controller.toggleTerms,
                              ),
                              Expanded(
                                child: Text(
                                  'I agree with the Terms of Service & Privacy Policy',
                                  style: textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        CustomButton(
                          text: controller.isLoading.value
                              ? "Creating Account..."
                              : "Sign Up",
                          onTap: controller.signUp,
                        ),

                        const Spacer(flex: 2),

                        Padding(
                          padding: const .only(bottom: 40),
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: RichText(
                              text: TextSpan(
                                text: "Have an account? ",
                                style: textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: "Log in",
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: .w700,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
