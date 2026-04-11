import 'package:doctor_hunt/controllers/auth_controller/login_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
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
                    key: controller.loginFormKey,
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        const Spacer(flex: 1),
                        Text('Welcome Back', style: textTheme.headlineMedium),
                        const SizedBox(height: 15),
                        Text(
                          'You can search doctors, book appointments and manage your health records effortlessly',
                          textAlign: .center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 40),
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
                          keyboardType: .visiblePassword,
                          textInputAction: .done,
                          prefixIcon: Icons.lock_outline,
                          validator: (val) => (val?.length ?? 0) >= 6
                              ? null
                              : "Password too short",
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          text: "Login",
                          onTap: controller.login,
                          height: 54,
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => _showForgotPassword(context),
                          child: Text(
                            "Forgot Password?",
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                        Padding(
                          padding: const .only(bottom: 40.0),
                          child: GestureDetector(
                            onTap: () => Get.toNamed('/signup'),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: "Join us",
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

  void _showForgotPassword(BuildContext context) {
    CustomDialog.show(
      context,
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            "Forgot Password",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          const Text(
            "Enter your email to receive a 4-digit code",
            textAlign: .center,
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: controller.forgotEmailController,
            hintText: "Email",
            prefixIcon: Icons.email_outlined,
            keyboardType: .emailAddress,
            textInputAction: .done,
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Continue",
            onTap: () => controller.verifyEmailAndStepNext(
              context,
              () => _showOTPDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showOTPDialog(BuildContext context) {
    CustomDialog.show(
      context,
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            "Verify Code",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: List.generate(
              4,
              (index) => SizedBox(
                width: 50,
                child: TextFormField(
                  controller: controller.otpControllers[index],
                  focusNode: controller.otpFocusNodes[index],
                  textAlign: .center,
                  keyboardType: .number,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: .w700,
                    color: AppColors.primary,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(borderRadius: .circular(12)),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 3) {
                      controller.otpFocusNodes[index + 1].requestFocus();
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Verify",
            onTap: () => controller.verifyOTPAndStepNext(
              () => _showResetPasswordDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    CustomDialog.show(
      context,
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            "Reset Password",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: controller.newPasswordController,
            hintText: "New Password",
            isPassword: true,
            keyboardType: .visiblePassword,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: controller.confirmPasswordController,
            hintText: "Confirm Password",
            isPassword: true,
            textInputAction: .done,
          ),
          const SizedBox(height: 25),
          CustomButton(text: "Update", onTap: controller.resetPassword),
        ],
      ),
    );
  }
}
