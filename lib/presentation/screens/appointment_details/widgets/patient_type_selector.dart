import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientTypeSelector extends StatelessWidget {
  const PatientTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final textTheme = Theme.of(context).textTheme;

    final List<Map<String, dynamic>> profiles = [
      {"name": "My Self", "icon": Icons.person_rounded},
      {"name": "My child", "icon": Icons.child_care_rounded},
      {"name": "Other", "icon": Icons.group_rounded},
    ];

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("Who is this patient?", style: textTheme.bodyLarge),
        const SizedBox(height: 15),
        SizedBox(
          height: 145,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            itemCount: profiles.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    controller.selectedPatientType.value = "Adding_New";

                    final tempNameController = TextEditingController();
                    final tempRelationController = TextEditingController();

                    Get.bottomSheet(
                      Padding(
                        padding: .only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          padding: const .all(24),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: .circular(20),
                              topRight: .circular(20),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "Add Dependent",
                                  style: textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Enter the details of the family member or person you are booking for",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: .w500,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                CustomTextField(
                                  controller: tempNameController,
                                  hintText: "Full Name",
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 15),

                                CustomTextField(
                                  controller: tempRelationController,
                                  hintText:
                                      "Relationship (e.g., Son, Wife, Father)",
                                  prefixIcon: Icons.family_restroom,
                                ),
                                const SizedBox(height: 25),

                                CustomButton(
                                  text: "Save & Continue",
                                  onTap: () {
                                    Get.back();
                                    controller.selectedPatientType.value =
                                        "Other";

                                    controller.patientNameController.text =
                                        tempNameController.text;

                                    AppSnackBar.show(
                                      title: "Profile Added",
                                      message:
                                          "${tempNameController.text} has been selected",
                                    );
                                  },
                                  borderRadius: 10,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      isScrollControlled: true,
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: .circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Add",
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: .w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final profile = profiles[index - 1];

              return Obx(() {
                final isSelected =
                    controller.selectedPatientType.value == profile['name'];

                return GestureDetector(
                  onTap: () {
                    controller.selectedPatientType.value = profile['name']!;
                    if (profile['name'] == 'My Self') {
                      controller.patientNameController.text = "John Doe";
                    } else {
                      controller.patientNameController.clear();
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.05)
                              : AppColors.secondary.withValues(alpha: 0.01),
                          borderRadius: .circular(12),
                          border: .all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.secondary.withValues(alpha: 0.2),
                            width: isSelected ? 2.5 : 1.0,
                          ),
                        ),
                        child: Icon(
                          profile['icon'],
                          size: 45,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.secondary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile['name']!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isSelected ? .w700 : .w500,
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
