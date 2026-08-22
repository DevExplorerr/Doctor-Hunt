import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MainWrapper(
      child: Column(
        children: [
          const CustomAppBar(title: "Privacy & Policy"),
          Expanded(
            child: SingleChildScrollView(
              padding: const .all(15),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Doctor Hunt Privacy Policy",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: .w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSection(
                    context,
                    "1. Data Collection",
                    "We collect personal information that you provide to us, such as name, address, contact information, and medical records necessary for scheduling appointments and processing medicine orders.",
                  ),
                  _buildSection(
                    context,
                    "2. Use of Your Information",
                    "Your information is used strictly to provide and improve our healthcare services. We use your data to process orders, facilitate doctor consultations, and send important service updates.",
                  ),
                  _buildSection(
                    context,
                    "3. Data Security",
                    "We implement a variety of security measures to maintain the safety of your personal information. All medical and payment data is encrypted and securely stored.",
                  ),
                  _buildSection(
                    context,
                    "4. Sharing with Third Parties",
                    "We do not sell, trade, or otherwise transfer your Personally Identifiable Information to outside parties, except trusted healthcare providers directly involved in your care.",
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const .only(bottom: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: .w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
