import 'package:doctor_hunt/controllers/pharmacy_controller.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/medicine_details_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/medicine_grid_card.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/shimmer/search_medicine_shimmer.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchMedicinesScreen extends StatelessWidget {
  const SearchMedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PharmacyController controller = Get.find<PharmacyController>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MainWrapper(
        child: Column(
          children: [
            const CustomAppBar(title: "Search Medicines"),
            Padding(
              padding: const .symmetric(horizontal: 15),
              child: CustomSearchBar(
                hintText: "Search medicines...",
                focusNode: controller.focusNode,
                controller: controller.searchController,
                onChanged: controller.handleSearch,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                final searchResults = [
                  ...controller.filteredTablets,
                  ...controller.filteredSyrups,
                ];

                if (controller.isSearching.value) {
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
                  padding: const .only(
                    left: 15,
                    right: 15,
                    top: 15,
                    bottom: 30,
                  ),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final product = searchResults[index];
                    return MedicineGridCard(
                      id: product.id,
                      name: product.name,
                      quantity: product.quantity,
                      image: product.image,
                      price: product.price,
                      onTap: () {
                        Get.to(() => MedicineDetailsScreen(medicine: product));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
