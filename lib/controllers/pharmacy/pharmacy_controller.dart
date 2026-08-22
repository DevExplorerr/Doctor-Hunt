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

  var searchDatabase = <PharmacyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardPreviews();
  }

  Future<void> fetchDashboardPreviews() async {
    isLoading.value = true;

    final results = await Future.wait([
      _repository.getMedicinesByCategory('Tablet', limit: 5),
      _repository.getMedicinesByCategory('Syrup', limit: 5),
    ]);

    allTablets.assignAll(results[0]);
    allSyrups.assignAll(results[1]);

    isLoading.value = false;
  }

  Future<List<PharmacyModel>> fetchFullCategory(String category) async {
    return await _repository.getMedicinesByCategory(category);
  }

  Future<void> openSearchScreen() async {
    searchController.clear();
    searchQuery.value = '';

    if (searchDatabase.isEmpty) {
      searchDatabase.value = await _repository.getAllMedicinesForSearch();
    }

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

  List<PharmacyModel> get filteredSearchMedicines {
    if (searchQuery.value.isEmpty) return searchDatabase;
    return searchDatabase
        .where(
          (med) =>
              med.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
