import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;

  const CustomSearchBar({super.key, required this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      keyboardType: .text,
      textInputAction: .search,
      textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyLarge),
      hintText: hintText,
      padding: const WidgetStatePropertyAll(.symmetric(horizontal: 10)),
      hintStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium),
      leading: const Icon(Icons.search, color: AppColors.icon),
      trailing: [
        IconButton(
          icon: const Icon(Icons.clear, color: AppColors.icon),
          onPressed: () {
            controller?.clear();
            FocusScope.of(context).unfocus();
          },
        ),
      ],
      backgroundColor: const WidgetStatePropertyAll(AppColors.white),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: .all(.circular(6))),
      ),
      shadowColor: const WidgetStatePropertyAll(AppColors.black),
    );
  }
}
