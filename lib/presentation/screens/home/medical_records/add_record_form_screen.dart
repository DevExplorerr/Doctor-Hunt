import 'package:doctor_hunt/controllers/medical_record_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddRecordFormScreen extends StatelessWidget {
  const AddRecordFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicalRecordController>();
    final textTheme = Theme.of(context).textTheme;
    final String todayDate = DateFormat('dd MMM, yyyy').format(DateTime.now());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainWrapper(
        child: Column(
          children: [
            const CustomAppBar(title: "Add Records"),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const .all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final file = controller.selectedFile.value;
                      final fileName = controller.selectedFileName.value
                          .toLowerCase();
                      final isPdf = fileName.endsWith('.pdf');
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.grey.withValues(alpha: 0.2),
                          image: (file != null && !isPdf)
                              ? DecorationImage(
                                  image: FileImage(file),
                                  fit: .cover,
                                )
                              : null,
                        ),
                        child: file == null
                            ? const Icon(
                                Icons.insert_drive_file,
                                color: AppColors.grey,
                              )
                            : isPdf
                            ? const Column(
                                mainAxisAlignment: .center,
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf_rounded,
                                    color: AppColors.red,
                                    size: 35,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "PDF",
                                    style: TextStyle(
                                      color: AppColors.red,
                                      fontWeight: .bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      );
                    }),
                    const SizedBox(height: 40),

                    Text(
                      "Record for",
                      style: textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.titleController,
                      hintText: "E.g. John Doe",
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.doctorNameController,
                      hintText: "Enter Doctor Name",
                    ),
                    const SizedBox(height: 25),

                    Text(
                      "Type of record",
                      style: textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: 15),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: .spaceAround,
                        children: [
                          _buildTypeChip(
                            Icons.receipt_long,
                            "Prescription",
                            controller,
                            textTheme,
                          ),
                          _buildTypeChip(
                            Icons.description,
                            "Report",
                            controller,
                            textTheme,
                          ),
                          _buildTypeChip(
                            Icons.receipt,
                            "Invoice",
                            controller,
                            textTheme,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 30),

                    Text(
                      "Record created on",
                      style: textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      todayDate,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const .all(20.0),
              child: Obx(() {
                return CustomButton(
                  text: "Upload record",
                  height: 54,
                  isLoading: controller.isUploading.value,
                  onTap: () async {
                    bool success = await controller.saveRecord();
                    if (success) {
                      Get.back();
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    IconData icon,
    String label,
    MedicalRecordController controller,
    TextTheme textTheme,
  ) {
    final bool isActive = controller.selectedRecordType.value == label;
    return GestureDetector(
      onTap: () {
        controller.selectedRecordType.value = label;
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : AppColors.secondary.withValues(alpha: 0.5),
              size: 30,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? .bold : .normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
