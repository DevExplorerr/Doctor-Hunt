import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  final forgotEmailController = TextEditingController();

  final isLoading = false.obs;

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      if (isLoading.value) return;

      try {
        isLoading.value = true;

        await AuthRepository.instance.signInWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        AppSnackBar.show(
          title: "Success",
          message: "Logged in Successfully",
          snackPosition: .BOTTOM,
        );

        Get.offAllNamed('/home');
      } catch (e) {
        AppSnackBar.show(
          title: "Login Failed",
          message: e.toString(),
          isError: true,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> sendPasswordReset() async {
    if (GetUtils.isEmail(forgotEmailController.text.trim())) {
      try {
        isLoading.value = true;

        await AuthRepository.instance.sendPasswordResetEmail(
          forgotEmailController.text.trim(),
        );

        Get.back();

        AppSnackBar.show(
          title: "Email Sent",
          message: "Check your inbox for a link to reset your password.",
        );
      } catch (e) {
        AppSnackBar.show(title: "Error", message: e.toString(), isError: true);
      } finally {
        isLoading.value = false;
      }
    } else {
      AppSnackBar.show(
        title: "Error",
        message: "Enter a valid email",
        isError: true,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    forgotEmailController.dispose();
    super.onClose();
  }
}
