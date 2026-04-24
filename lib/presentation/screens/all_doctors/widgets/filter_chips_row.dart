import 'package:doctor_hunt/controllers/all_doctors_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterChipsRow extends StatelessWidget {
  final AllDoctorsController controller;
  const FilterChipsRow({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    final List<String> filters = [
      "All",
      "Dermatologist",
      "General Physician",
      "Surgeon",
      "Orthopedic",
      "Psychologist",
      "Gynecologist",
      "Neurologist",
      "Dentist",
      "Pediatrician",
      "Cardiologist",
      "Medicine",
    ];

    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: .horizontal,
        padding: const .symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const .only(right: 10),
            child: Obx(() {
              final isSelected =
                  controller.selectedFilter.value == filters[index];
              return ChoiceChip(
                label: Text(filters[index]),
                selected: isSelected,
                onSelected: (bool selected) {
                  controller.selectedFilter.value = filters[index];
                  controller.filterByCategory(filters[index]);
                },
                selectedColor: AppColors.primary,
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                  fontWeight: .w600,
                ),
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                side: .none,
              );
            }),
          );
        },
      ),
    );
  }
}
