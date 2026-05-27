import 'package:doctor_hunt/controllers/favorite_controller.dart';
import 'package:doctor_hunt/data/models/user_model.dart';
import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/data/repositories/user_repository.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final UserRepository _repo = UserRepository.instance;

  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  late TextEditingController nameFieldController;
  late TextEditingController emailFieldController;
  late TextEditingController phoneFieldController;

  @override
  void onInit() {
    super.onInit();
    nameFieldController = TextEditingController();
    emailFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    fetchUserProfile();
  }

  @override
  void onClose() {
    nameFieldController.dispose();
    emailFieldController.dispose();
    phoneFieldController.dispose();
    super.onClose();
  }

  void _initializeFormFields(UserModel? profile) {
    if (profile != null) {
      nameFieldController.text = profile.name;
      emailFieldController.text = profile.email;
      phoneFieldController.text = profile.phone;
    }
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      user.value = await _repo.getUserRecord();
      _initializeFormFields(user.value);
    } catch (e) {
      AppSnackBar.show(
        title: "Error",
        message: "Could not load profile data.",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfileDetails() async {
    final String cleanName = nameFieldController.text.trim();
    final String cleanPhone = phoneFieldController.text.trim();

    if (cleanName.isEmpty) {
      AppSnackBar.show(
        title: "Required",
        message: "Name field cannot be left completely blank.",
        isError: true,
      );
      return false;
    }

    isLoading.value = true;
    try {
      final Map<String, dynamic> updatePayload = {
        'name': cleanName,
        'phone': cleanPhone,
      };

      await _repo.updateUserRecord(updatePayload);

      if (user.value != null) {
        user.value = UserModel(
          id: user.value!.id,
          name: cleanName,
          email: user.value!.email,
          phone: cleanPhone,
          avatar: user.value!.avatar,
        );
      }

      return true;
    } catch (e) {
      AppSnackBar.show(
        title: "Update Error",
        message: e.toString(),
        isError: true,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await AuthRepository.instance.logout();

      if (Get.isRegistered<FavoriteController>()) {
        Get.find<FavoriteController>().clearFavoritesOnLogout();
      }

      user.value = null;
      AppSnackBar.show(title: "Success", message: "Sign Out Successfully");
      Get.offAllNamed('/login');
    } catch (e) {
      AppSnackBar.show(
        title: "Logout Error",
        message: "Failed to sign out",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
