import 'package:doctor_hunt/data/models/pharmacy_model.dart';
import 'package:doctor_hunt/data/repositories/pharmacy_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PharmacyController extends GetxController {
  final PharmacyRepository _repository = PharmacyRepository();

  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  var isLoading = true.obs;
  var searchQuery = ''.obs;
  final isSearching = false.obs;

  var allTablets = <PharmacyModel>[].obs;
  var allSyrups = <PharmacyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    isLoading.value = true;

    final List<PharmacyModel> fetchedMedicines = await _repository
        .getAllMedicines();

    allTablets.clear();
    allSyrups.clear();

    for (var medicine in fetchedMedicines) {
      if (medicine.category.toLowerCase() == 'tablet') {
        allTablets.add(medicine);
      } else if (medicine.category.toLowerCase() == 'syrup') {
        allSyrups.add(medicine);
      }
    }

    isLoading.value = false;
  }

  List<PharmacyModel> get filteredTablets {
    if (searchQuery.value.isEmpty) return allTablets;
    return allTablets
        .where(
          (med) =>
              med.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  List<PharmacyModel> get filteredSyrups {
    if (searchQuery.value.isEmpty) return allSyrups;
    return allSyrups
        .where(
          (med) =>
              med.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  Future<void> openSearchScreen() async {
    searchController.clear();
    searchQuery.value = '';
    Future.delayed(const Duration(milliseconds: 300), () {
      focusNode.requestFocus();
    });
    await Get.toNamed('/search-medicines');
    searchController.clear();
    searchQuery.value = '';
    focusNode.unfocus();
  }

  Future<void> handleSearch(String query) async {
    isSearching.value = true;

    searchQuery.value = query;

    await Future.delayed(const Duration(milliseconds: 400));

    isSearching.value = false;
  }

  @override
  void onClose() {
    searchController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
