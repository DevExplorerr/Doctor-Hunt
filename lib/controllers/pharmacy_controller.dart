import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PharmacyController extends GetxController {
  var searchQuery = ''.obs;
  FocusNode focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  void openSearchScreen() {
    searchController.clear();
    searchQuery.value = '';

    Get.toNamed('/search-medicines');

    Future.delayed(const Duration(milliseconds: 300), () {
      focusNode.requestFocus();
    });
  }

  final List<Map<String, dynamic>> allTablets = [
    {
      "name": "Xanax",
      "quantity": "1 mg tablet",
      "image": "assets/images/medicine_screen/medicines/xanax_tablet.png",
      "price": 1.00,
    },
    {
      "name": "Vosevi",
      "quantity": "100 mg tablet",
      "image": "assets/images/medicine_screen/medicines/vosevi_tablet.png",
      "price": 2.20,
    },
    {
      "name": "Paracetamol",
      "quantity": "100 tablets",
      "image": "assets/images/medicine_screen/medicines/paracetamol_tablet.png",
      "price": 6.30,
    },
    {
      "name": "Panadol",
      "quantity": "500 mg tablet",
      "image": "assets/images/medicine_screen/medicines/panadol_tablet.png",
      "price": 4.00,
    },
  ];

  final List<Map<String, dynamic>> allSyrups = [
    {
      "name": "Benylin Syrup",
      "quantity": "300 ml",
      "image": "assets/images/medicine_screen/medicines/benylin_syrup.png",
      "price": 20.00,
    },
    {
      "name": "Calmo Syrup",
      "quantity": "200 ml",
      "image": "assets/images/medicine_screen/medicines/calmo_syrup.png",
      "price": 18.00,
    },
    {
      "name": "Cough Syrup",
      "quantity": "220 ml",
      "image": "assets/images/medicine_screen/medicines/cough_syrup.png",
      "price": 12.50,
    },
    {
      "name": "Immu Syrup",
      "quantity": "250 ml",
      "image": "assets/images/medicine_screen/medicines/immu_syrup.png",
      "price": 8.75,
    },
  ];

  List<Map<String, dynamic>> get filteredTablets {
    if (searchQuery.value.isEmpty) return allTablets;
    return allTablets
        .where(
          (product) => product['name'].toString().toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> get filteredSyrups {
    if (searchQuery.value.isEmpty) return allSyrups;
    return allSyrups
        .where(
          (product) => product['name'].toString().toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  @override
  void onClose() {
    focusNode.dispose();
    searchController.dispose();
    super.onClose();
  }
}
