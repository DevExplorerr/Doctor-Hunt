import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final Color? buttonColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final Color? textColor;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height,
    this.width,
    this.buttonColor,
    this.foregroundColor,
    this.borderRadius,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final double responsiveHeight =
        height ?? (size.height * 0.065).clamp(54.0, 65.0);

    final double responsiveFontSize =
        fontSize ?? (size.width * 0.045).clamp(14.0, 18.0);

    return SizedBox(
      width: width ?? .infinity,
      height: responsiveHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const .symmetric(horizontal: 16),
          backgroundColor: buttonColor ?? theme.primaryColor,
          foregroundColor:
              foregroundColor ?? AppColors.white.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: .circular(borderRadius ?? 10),
          ),
        ),
        onPressed: onTap,
        child: FittedBox(
          fit: .scaleDown,
          child: Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor ?? AppColors.white,
              fontSize: responsiveFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
