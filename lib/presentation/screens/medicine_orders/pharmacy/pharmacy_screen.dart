import 'package:doctor_hunt/controllers/pharmacy_controller.dart';
import 'package:doctor_hunt/data/models/pharmacy_model.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/all_medicines_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/medicine_details_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/medicine_horizontal_card.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/shimmer/pharmacy_shimmer.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PharmacyController pharmacyController = Get.put(PharmacyController());

    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "Pharmacy", showCart: true),
          Padding(
            padding: const .only(left: 15, right: 15, bottom: 15),
            child: CustomSearchBar(
              hintText: "Search medicines...",
              readOnly: true,
              onTap: () {
                pharmacyController.openSearchScreen();
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const .symmetric(horizontal: 15),
              child: Obx(() {
                return Column(
                  children: [
                    if (pharmacyController.isLoading.value)
                      const PharmacyShimmer(),
                    if (!pharmacyController.isLoading.value &&
                        pharmacyController.allTablets.isNotEmpty) ...[
                      const SizedBox(height: 25),
                      ProductCategorySection(
                        title: "Tablets",
                        products: pharmacyController.allTablets
                            .take(5)
                            .toList(),
                        onSeeAll: () {
                          Get.to(
                            () => AllMedicinesScreen(
                              categoryTitle: "All Tablets",
                              products: pharmacyController.allTablets.toList(),
                            ),
                          );
                        },
                      ),
                    ],
                    if (!pharmacyController.isLoading.value &&
                        pharmacyController.allSyrups.isNotEmpty) ...[
                      const SizedBox(height: 25),
                      ProductCategorySection(
                        title: "Syrup",
                        products: pharmacyController.allSyrups.take(5).toList(),
                        onSeeAll: () {
                          Get.to(
                            () => AllMedicinesScreen(
                              categoryTitle: "All Syrups",
                              products: pharmacyController.allSyrups.toList(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCategorySection extends StatelessWidget {
  final String title;
  final List<PharmacyModel> products;
  final VoidCallback onSeeAll;

  const ProductCategorySection({
    super.key,
    required this.title,
    required this.products,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeadline(onlyText: false, onPressed: onSeeAll, text: title),
        const SizedBox(height: 10),
        SizedBox(
          height: 270,
          child: SingleChildScrollView(
            scrollDirection: .horizontal,
            clipBehavior: .none,
            child: Row(
              children: products.map((product) {
                return Padding(
                  padding: const .only(right: 15.0),
                  child: MedicineHorizontalCard(
                    id: product.id,
                    name: product.name,
                    quantity: product.quantity,
                    image: product.image,
                    price: product.price,
                    onTap: () {
                      Get.to(() => MedicineDetailsScreen(medicine: product));
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
