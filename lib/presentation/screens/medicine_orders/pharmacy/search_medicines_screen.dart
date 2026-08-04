import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/controllers/pharmacy_controller.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/medicine_card.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/search_medicine_shimmer.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchMedicinesScreen extends StatefulWidget {
  const SearchMedicinesScreen({super.key});

  @override
  State<SearchMedicinesScreen> createState() => _SearchMedicinesScreenState();
}

class _SearchMedicinesScreenState extends State<SearchMedicinesScreen> {
  final PharmacyController controller = Get.find<PharmacyController>();
  final CartController cartController = Get.find<CartController>();

  bool isSearching = false;

  void handleSearch(String val) async {
    setState(() => isSearching = true);
    controller.updateSearch(val);

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() => isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "Search Medicines"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomSearchBar(
              hintText: "Search medicines...",
              focusNode: controller.focusNode,
              controller: controller.searchController,
              onChanged: handleSearch,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Obx(() {
              final searchResults = [
                ...controller.filteredTablets,
                ...controller.filteredSyrups,
              ];

              if (isSearching) {
                return const SearchMedicineShimmer();
              }

              if (searchResults.isEmpty) {
                return const AppEmptyState(
                  title: 'No medicines found.',
                  description:
                      'Try searching for a different medicine name or category.',
                  icon: Icons.search_off_rounded,
                );
              }

              return GridView.builder(
                padding: const .only(left: 15, right: 15, top: 15, bottom: 30),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final product = searchResults[index];
                  return MedicineCard(
                    name: product['name'],
                    quantity: product['quantity'],
                    image: product['image'],
                    price: product['price'],
                    cartController: cartController,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
