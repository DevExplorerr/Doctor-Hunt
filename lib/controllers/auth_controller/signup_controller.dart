import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final signupFormKey = GlobalKey<FormState>();

  var isTermsAgreed = false.obs;
  final isLoading = false.obs;

  void toggleTerms(bool? value) => isTermsAgreed.value = value ?? false;

  Future<void> signUp() async {
    if (signupFormKey.currentState!.validate()) {
      if (!isTermsAgreed.value) {
        AppSnackBar.show(
          title: "Notice",
          message: "Please agree to the Terms of Service",
          isError: true,
        );
        return;
      }

      if (isLoading.value) return;

      try {
        isLoading.value = true;

        await AuthRepository.instance.signUpWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
        );

        AppSnackBar.show(
          title: "Success",
          message: "Account Created Successfully",
          snackPosition: .BOTTOM,
        );

        Get.offAllNamed('/home');
      } catch (e) {
        AppSnackBar.show(
          title: "Sign Up Failed",
          message: e.toString(),
          isError: true,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
