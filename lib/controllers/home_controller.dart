import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/doctor_repository.dart';

class HomeController extends GetxController {
  final DoctorRepository _repo = DoctorRepository.instance;
  final TextEditingController searchController = TextEditingController();

  var userName = "User".obs;

  var selectedIndex = 0.obs;
  var isLoading = false.obs;

  var popularDoctors = <DoctorModel>[].obs;
  var featureDoctors = <DoctorModel>[].obs;
  var liveDoctors = <DoctorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    getUserName();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _repo.getPopularDoctors(),
        _repo.getFeatureDoctors(),
        _repo.getLiveDoctors(),
      ]);

      popularDoctors.assignAll(results[0]);
      featureDoctors.assignAll(results[1]);
      liveDoctors.assignAll(results[2]);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserName() async {
    try {
      final userData = await AuthRepository.instance.fetchUserName();

      if (userData != null) {
        userName.value = userData['name'] ?? "No Username";
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void changeTabIndex(int index) => selectedIndex.value = index;

  void viewAll(String type, String title) {
    Get.toNamed('/all-doctors', arguments: {'type': type, 'title': title});
  }
}
