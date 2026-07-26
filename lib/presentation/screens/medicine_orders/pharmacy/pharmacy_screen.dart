import 'package:doctor_hunt/controllers/cart_controller.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "Pharmacy"),
          const Padding(
            padding: .only(left: 15, right: 15, bottom: 15),
            child: CustomSearchBar(hintText: "Search..."),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const .symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  ProductCategorySection(
                    title: "Tablets",
                    cartController: cartController,
                    products: const [
                      {
                        "name": "Xanax",
                        "quantity": "1 mg tablet",
                        "image":
                            "assets/images/medicine_screen/medicines/xanax_tablet.png",
                        "price": 1.00,
                      },
                      {
                        "name": "Vosevi",
                        "quantity": "100 mg tablet",
                        "image":
                            "assets/images/medicine_screen/medicines/vosevi_tablet.png",
                        "price": 2.20,
                      },
                      {
                        "name": "Paracetamol",
                        "quantity": "100 tablets",
                        "image":
                            "assets/images/medicine_screen/medicines/paracetamol_tablet.png",
                        "price": 6.30,
                      },
                      {
                        "name": "Panadol",
                        "quantity": "500 mg tablet",
                        "image":
                            "assets/images/medicine_screen/medicines/panadol_tablet.png",
                        "price": 4.00,
                      },
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Reusable section for Syrups
                  ProductCategorySection(
                    title: "Syrup",
                    cartController: cartController,
                    products: const [
                      {
                        "name": "Benylin Syrup",
                        "quantity": "300 ml",
                        "image":
                            "assets/images/medicine_screen/medicines/benylin_syrup.png",
                        "price": 20.00,
                      },
                      {
                        "name": "Calmo Syrup",
                        "quantity": "200 ml",
                        "image":
                            "assets/images/medicine_screen/medicines/calmo_syrup.png",
                        "price": 18.00,
                      },
                      {
                        "name": "Cough Syrup",
                        "quantity": "220 ml",
                        "image":
                            "assets/images/medicine_screen/medicines/cough_syrup.png",
                        "price": 12.50,
                      },
                      {
                        "name": "Immu Syrup",
                        "quantity": "250 ml",
                        "image":
                            "assets/images/medicine_screen/medicines/immu_syrup.png",
                        "price": 8.75,
                      },
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
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

  const ProductCategorySection({
    super.key,
    required this.title,
    required this.cartController,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeadline(onlyText: false, onPressed: () {}, text: title),
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
