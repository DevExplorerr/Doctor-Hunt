import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  final forgotEmailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final otpControllers = List.generate(4, (_) => TextEditingController());
  final otpFocusNodes = List.generate(4, (_) => FocusNode());

  void login() {
    if (loginFormKey.currentState!.validate()) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed('/home');
      });
    }
  }

  void verifyEmailAndStepNext(BuildContext context, Function nextStep) {
    if (GetUtils.isEmail(forgotEmailController.text)) {
      Get.back();
      nextStep();
    } else {
      AppSnackBar.show(
        title: "Error",
        message: "Enter a valid email",
        isError: true,
      );
    }
  }

  void verifyOTPAndStepNext(Function nextStep) {
    String code = otpControllers.map((e) => e.text).join();
    if (code.length == 4) {
      Get.back();
      nextStep();
    } else {
      AppSnackBar.show(
        title: "Error",
        message: "Enter the full 4-digit code",
        isError: true,
      );
    }
  }

  void resetPassword() {
    if (newPasswordController.text == confirmPasswordController.text &&
        newPasswordController.text.length >= 6) {
      Get.back();
      AppSnackBar.show(
        title: "Success",
        message: "Password updated! Please login.",
      );
    } else {
      AppSnackBar.show(
        title: "Error",
        message: "Passwords must match and be 6+ chars",
        isError: true,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
