import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/medicine_card.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllMedicinesScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Map<String, dynamic>> products;

  const AllMedicinesScreen({
    super.key,
    required this.categoryTitle,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return MainWrapper(
      child: Column(
        children: [
          CustomAppBar(title: categoryTitle),
          Expanded(
            child: GridView.builder(
              padding: const .all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return MedicineCard(
                  name: product['name'],
                  quantity: product['quantity'],
                  image: product['image'],
                  price: product['price'],
                  cartController: cartController,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
