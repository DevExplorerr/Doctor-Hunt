import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/controllers/medical_record_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/home/pharmacy/widgets/medical_record_card.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/overlays/custom_bottom_sheet.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicalRecordController());

    return MainWrapper(
      child: Column(
        children: [
          CustomAppBar(
            title: "Medical Records",
            onBackPressed: () {
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().changeTabIndex(0);
              } else {
                Get.back();
              }
            },
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.records.isEmpty) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.primary,
                    size: 40,
                  ),
                );
              }

              if (controller.records.isEmpty) {
                return const Padding(
                  padding: .symmetric(horizontal: 15),
                  child: AppEmptyState(
                    title: "Add a medical record",
                    description:
                        "A detailed health history helps a doctor diagnose you better",
                    icon: Icons.receipt_long_rounded,
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const .symmetric(horizontal: 20, vertical: 20),
                itemCount: controller.records.length,
                itemBuilder: (context, index) {
                  return MedicalRecordCard(record: controller.records[index]);
                },
              );
            }),
          ),

          Padding(
            padding: const .all(20.0),
            child: CustomButton(
              height: 54,
              text: "Add a record",
              onTap: () {
                CustomBottomSheet.show(
                  title: "Add a record",
                  actions: [
                    BottomSheetActionTile(
                      icon: Icons.camera_alt_outlined,
                      title: "Take a photo",
                      onTap: () {
                        // TODO: Implement camera logic
                      },
                    ),
                    BottomSheetActionTile(
                      icon: Icons.image_outlined,
                      title: "Upload from gallery",
                      onTap: () async {
                        Get.back();
                        await controller.pickFile();
                        if (controller.selectedFile.value != null) {
                          Get.toNamed('/add-record-form');
                        }
                      },
                    ),
                    BottomSheetActionTile(
                      icon: Icons.description_outlined,
                      title: "Upload files",
                      onTap: () async {
                        Get.back();
                        await controller.pickFile();
                        if (controller.selectedFile.value != null) {
                          Get.toNamed('/add-record-form');
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
