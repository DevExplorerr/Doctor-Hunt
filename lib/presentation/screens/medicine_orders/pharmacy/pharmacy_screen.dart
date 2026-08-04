import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/controllers/pharmacy_controller.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/all_medicines_screen.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/medicine_card.dart';
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
    final CartController cartController = Get.put(CartController());
    final PharmacyController pharmacyController = Get.put(PharmacyController());

    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "Pharmacy"),
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
                    const SizedBox(height: 25),
                    if (pharmacyController.filteredTablets.isNotEmpty)
                      ProductCategorySection(
                        title: "Tablets",
                        cartController: cartController,
                        products: pharmacyController.filteredTablets,
                        onSeeAll: () {
                          Get.to(
                            () => AllMedicinesScreen(
                              categoryTitle: "All Tablets",
                              products: pharmacyController.allTablets,
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),

                    if (pharmacyController.filteredSyrups.isNotEmpty)
                      ProductCategorySection(
                        title: "Syrup",
                        cartController: cartController,
                        products: pharmacyController.filteredSyrups,
                        onSeeAll: () {
                          Get.to(
                            () => AllMedicinesScreen(
                              categoryTitle: "All Syrups",
                              products: pharmacyController.allSyrups,
                            ),
                          );
                        },
                      ),
                    if (pharmacyController.filteredTablets.isEmpty &&
                        pharmacyController.filteredSyrups.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text("No medicines found for your search."),
                      ),
                    const SizedBox(height: 20),
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
  final CartController cartController;
  final List<Map<String, dynamic>> products;
  final VoidCallback onSeeAll;

  const ProductCategorySection({
    super.key,
    required this.title,
    required this.cartController,
    required this.products,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeadline(onlyText: false, onPressed: onSeeAll, text: title),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: .horizontal,
          clipBehavior: .none,
          child: Row(
            children: products.map((product) {
              return Padding(
                padding: const .only(right: 15.0),
                child: MedicineCard(
                  name: product['name'],
                  quantity: product['quantity'],
                  image: product['image'],
                  price: product['price'],
                  cartController: cartController,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
