import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final double amount;
  final bool isDiscount;

  const SummaryRow({
    super.key,
    required this.title,
    required this.amount,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          amount == 0 && isDiscount
              ? "\$0.00"
              : "${isDiscount ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}",
          style: textTheme.titleSmall?.copyWith(
            fontWeight: .w700,
            color: isDiscount && amount != 0
                ? AppColors.primary
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
