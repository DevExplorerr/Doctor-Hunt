import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final signupFormKey = GlobalKey<FormState>();

  var isTermsAgreed = false.obs;

  void toggleTerms(bool? value) => isTermsAgreed.value = value ?? false;

  void signUp() {
    if (signupFormKey.currentState!.validate()) {
      if (!isTermsAgreed.value) {
        AppSnackBar.show(
          title: "Notice",
          message: "Please agree to the Terms of Service",
          isError: true,
        );
        return;
      }

      Get.offAllNamed('/home');
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
