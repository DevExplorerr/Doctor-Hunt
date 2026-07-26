import 'package:doctor_hunt/presentation/screens/medicine_orders/widgets/empty_orders_view.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';

class EmptyOrdersScreen extends StatelessWidget {
  final String title;

  const EmptyOrdersScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      child: Column(
        children: [
          CustomAppBar(title: title),
          const Expanded(child: EmptyOrdersView()),
        ],
      ),
    );
  }
}
