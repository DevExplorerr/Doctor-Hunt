import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final VoidCallback? obscureOnpressed;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = .text,
    this.validator,
    this.textInputAction = .next,
    this.onChanged,
    this.obscureText = false,
    this.obscureOnpressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      style: textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.bodyMedium,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.icon)
            : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.icon,
                ),
                onPressed: obscureOnpressed,
              )
            : null,
      ),
    );
  }
}
