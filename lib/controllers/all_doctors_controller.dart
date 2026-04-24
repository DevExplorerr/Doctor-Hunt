import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/doctor_repository.dart';

class AllDoctorsController extends GetxController {
  final DoctorRepository _repo = DoctorRepository.instance;
  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  var allDoctors = <DoctorModel>[].obs;
  var filteredDoctors = <DoctorModel>[].obs;
  var isLoading = false.obs;

  var selectedFilter = "All".obs;
  var title = "Doctors".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    title.value = args?['title'] ?? "Doctors";

    if (args?['focusSearch'] == true) {
      Future.delayed(const Duration(milliseconds: 300), () {
        searchFocusNode.requestFocus();
      });
    }

    String? type = args?['type'];
    String? category = args?['category'];

    fetchInitialData(type: type, category: category);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchInitialData({
    String? type,
    String? category,
    String? query,
  }) async {
    try {
      isLoading.value = true;

      List<DoctorModel> results = await _repo.getAllDoctors();
      allDoctors.assignAll(results);

      if (category != null) {
        selectedFilter.value = category;
        filteredDoctors.assignAll(
          results.where((d) => d.specialty == category).toList(),
        );
      } else if (type == 'popular') {
        filteredDoctors.assignAll(results.where((d) => d.isPopular).toList());
      } else if (type == 'feature') {
        filteredDoctors.assignAll(results.where((d) => d.isFeature).toList());
      } else if (query != null && query.isNotEmpty) {
        searchController.text = query;
        searchDoctors(query);
        return;
      } else {
        filteredDoctors.assignAll(results);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(allDoctors);
    } else {
      filteredDoctors.assignAll(
        allDoctors
            .where(
              (d) =>
                  d.name.toLowerCase().contains(query.toLowerCase()) ||
                  d.specialty.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void filterByCategory(String category) {
    selectedFilter.value = category;
    if (category == "All") {
      filteredDoctors.assignAll(allDoctors);
    } else {
      filteredDoctors.assignAll(
        allDoctors
            .where(
              (d) => d.specialty.toLowerCase().contains(category.toLowerCase()),
            )
            .toList(),
      );
    }
  }
}
