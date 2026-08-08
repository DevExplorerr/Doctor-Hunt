import 'package:doctor_hunt/data/models/pharmacy_model.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/pharmacy/widgets/medicine_grid_card.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';

class AllMedicinesScreen extends StatelessWidget {
  final String categoryTitle;
  final List<PharmacyModel> products;

  const AllMedicinesScreen({
    super.key,
    required this.categoryTitle,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      child: Column(
        children: [
          CustomAppBar(title: categoryTitle),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;

                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 6;
                } else if (constraints.maxWidth >= 900) {
                  crossAxisCount = 5;
                } else if (constraints.maxWidth >= 700) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth >= 500) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }
                return GridView.builder(
                  padding: const .all(15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return MedicineGridCard(
                      name: product.name,
                      quantity: product.quantity,
                      image: product.image,
                      price: product.price,
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
