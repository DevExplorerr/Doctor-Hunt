import 'package:doctor_hunt/controllers/pharmacy/medicine_orders_controller.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/widgets/medicine_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineCategoryGrid extends StatelessWidget {
  const MedicineCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicineOrdersController>();
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const .only(left: 15, right: 15, top: 15, bottom: 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: controller.categories.length,
      itemBuilder: ((context, index) {
        final category = controller.categories[index];
        return GestureDetector(
          onTap: () {
            controller.handleCategoryTap(category["title"]);
          },
          child: MedicineGridItem(
            title: category['title'],
            icon: category['icon'],
          ),
        );
      }),
    );
  }
}
