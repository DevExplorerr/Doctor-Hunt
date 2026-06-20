import 'package:doctor_hunt/controllers/medical_record_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/data/models/medical_record_model.dart';
import 'package:doctor_hunt/presentation/screens/home/pharmacy/widgets/full_screen_image_viewer.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MedicalRecordCard extends StatelessWidget {
  final MedicalRecordModel record;

  const MedicalRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final String day = DateFormat('dd').format(record.createdAt);
    final String month = DateFormat(
      'MMM',
    ).format(record.createdAt).toUpperCase();

    return GestureDetector(
      onTap: () {
        Get.to(
          () => FullScreenImageViewer(
            imageUrl: record.fileUrl,
            title: record.title,
          ),
          transition: .zoom,
        );
      },
      child: Container(
        margin: const .only(bottom: 15),
        padding: const .all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Column(
              children: [
                Container(
                  padding: const .symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: .circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        day,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: .w700,
                        ),
                      ),
                      Text(
                        month,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const .symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(4),
                  ),
                  child: Text(
                    "NEW",
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: .w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Records added by you",
                    style: textTheme.titleMedium?.copyWith(fontWeight: .w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Record for ${record.title}",
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: .w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    record.recordType,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              color: AppColors.white,
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.icon),
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              onSelected: (value) {
                if (value == 'delete') {
                  CustomDialog.show(
                    context,
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Text(
                          "Delete Record",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.primary),
                        ),
                        Text(
                          "Are you sure you want to permanently delete this medical record?",
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: .center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  "Cancel",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                height: 45,
                                text: "Delete",
                                onTap: () {
                                  Get.back();
                                  Get.find<MedicalRecordController>()
                                      .deleteRecord(record.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.red,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Delete Record',
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: .w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
