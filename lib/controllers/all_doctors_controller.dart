import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/doctor_repository.dart';

class AllDoctorsController extends GetxController {
  final DoctorRepository _repo = DoctorRepository.instance;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode searchFocusNode = FocusNode();

  var allDoctors = <DoctorModel>[].obs;
  var filteredDoctors = <DoctorModel>[].obs;

  var isLoading = false.obs;
  var isSearching = false.obs;
  var isMoreLoading = false.obs;
  var hasMore = true.obs;

  DocumentSnapshot? _lastDocument;
  String? currentType;

  var selectedFilter = "All".obs;
  var title = "Doctors".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    String rawTitle = args?['title'] ?? "All";
    title.value = rawTitle.replaceAll("Doctors", "").trim();
    currentType = args?['type'];

    if (args?['focusSearch'] == true) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => searchFocusNode.requestFocus(),
      );
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isSearching.value &&
          hasMore.value) {
        fetchMoreDoctors();
      }
    });

    fetchInitialData(type: currentType, category: args?['category']);
  }

  Future<void> fetchInitialData({String? type, String? category}) async {
    try {
      isLoading.value = true;
      _lastDocument = null;
      hasMore.value = true;

      final result = await _repo.getAllDoctors(limit: 10, type: type);
      final List<DoctorModel> fetched = result['doctors'];
      _lastDocument = result['lastDocument'];

      if (fetched.length < 10) hasMore.value = false;

      allDoctors.assignAll(fetched);

      if (category != null) {
        selectedFilter.value = category;
        filteredDoctors.assignAll(
          allDoctors
              .where(
                (d) =>
                    d.specialty.toLowerCase().contains(category.toLowerCase()),
              )
              .toList(),
        );

        if (filteredDoctors.isEmpty) {
          filterByCategory(category);
        }
      } else {
        filteredDoctors.assignAll(allDoctors);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreDoctors() async {
    if (isMoreLoading.value || !hasMore.value) return;
    try {
      isMoreLoading.value = true;
      final result = await _repo.getAllDoctors(
        lastDocument: _lastDocument,
        limit: 10,
        type: currentType,
      );

      final List<DoctorModel> newDocs = result['doctors'];
      _lastDocument = result['lastDocument'];

      if (newDocs.length < 10) hasMore.value = false;

      allDoctors.addAll(newDocs);
      if (selectedFilter.value == "All") {
        filteredDoctors.addAll(newDocs);
      } else {
        filteredDoctors.addAll(
          newDocs.where(
            (d) =>
                d.specialty.toLowerCase() == selectedFilter.value.toLowerCase(),
          ),
        );
      }
    } finally {
      isMoreLoading.value = false;
    }
  }

  void searchDoctors(String query) async {
    if (query.isEmpty) {
      isSearching.value = false;
      filteredDoctors.assignAll(allDoctors);
      return;
    }
    isSearching.value = true;

    try {
      final result = await _repo.getAllDoctors(limit: 20, type: null);
      List<DoctorModel> searchResults = result['doctors'];
      filteredDoctors.assignAll(
        searchResults
            .where(
              (d) =>
                  d.name.toLowerCase().contains(query.toLowerCase()) ||
                  d.specialty.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
      hasMore.value = false;
    } catch (e) {
      throw "Search Error $e";
    } finally {
      isSearching.value = false;
    }
  }

  void filterByCategory(String category) async {
    selectedFilter.value = category;
    title.value = category;
    if (category == "All") {
      fetchInitialData(type: currentType);
    } else {
      isLoading.value = true;
      try {
        final results = await _repo.getDoctorsByCategory(category);
        allDoctors.assignAll(results);
        filteredDoctors.assignAll(results);
        hasMore.value = false;
        _lastDocument = null;
        currentType = null;
      } finally {
        isLoading.value = false;
      }
    }
  }

  void resetFilters() {
    selectedFilter.value = "All";
    title.value = "All";
    currentType = null;
    searchController.clear();

    fetchInitialData(type: null);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
