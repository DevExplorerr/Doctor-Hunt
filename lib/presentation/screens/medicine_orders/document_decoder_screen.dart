import 'package:doctor_hunt/controllers/decoder/decoder_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/widgets/decoder_result_card.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/overlays/custom_bottom_sheet.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentDecoderScreen extends StatelessWidget {
  const DocumentDecoderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DecoderController());

    return PopScope(
      canPop: controller.decoderState.value != DecoderState.analyzing,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && Get.isRegistered<DecoderController>()) {
          Get.delete<DecoderController>();
        }
      },
      child: MainWrapper(
        child: Column(
          children: [
            CustomAppBar(
              title: "Document Decoder",
              onBackPressed: () {
                if (controller.decoderState.value == DecoderState.analyzing) {
                  return;
                }
                if (Get.isRegistered<DecoderController>()) {
                  Get.delete<DecoderController>();
                }
                if (Navigator.of(context).canPop()) {
                  Get.back();
                } else {
                  Get.back();
                }
              },
            ),
            Expanded(
              child: Obx(() {
                switch (controller.decoderState.value) {
                  case DecoderState.idle:
                    return _buildIdleState(context, controller);
                  case DecoderState.fileSelected:
                    return _buildPreviewState(context, controller);
                  case DecoderState.analyzing:
                    return _buildAnalyzingState();
                  case DecoderState.success:
                    return _buildSuccessState(context, controller);
                  case DecoderState.failed:
                    return _buildFailedState(context, controller);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdleState(BuildContext context, DecoderController controller) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.document_scanner_outlined,
              color: AppColors.primary,
              size: 56,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Document Decoder',
            style: theme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Upload or capture a prescription, lab report, or medical document to get an AI-powered explanation.',
            style: theme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          CustomButton(
            text: 'Take Photo',
            height: 54,
            onTap: () => controller.takePhoto(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: () {
                CustomBottomSheet.show(
                  title: "Choose File",
                  actions: [
                    BottomSheetActionTile(
                      icon: Icons.image_outlined,
                      title: "Choose Image",
                      onTap: () {
                        Get.back();
                        controller.pickImage();
                      },
                    ),
                    BottomSheetActionTile(
                      icon: Icons.description_outlined,
                      title: "Choose File (Image or PDF)",
                      onTap: () {
                        Get.back();
                        controller.pickFile();
                      },
                    ),
                  ],
                );
              },
              icon: const Icon(Icons.folder_open, color: AppColors.primary),
              label: Text(
                'Choose File',
                style: theme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewState(
    BuildContext context,
    DecoderController controller,
  ) {
    final theme = Theme.of(context).textTheme;
    final file = controller.selectedFile.value;
    final fileName = controller.selectedFileName.value;
    final isPdf = controller.isPdf;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Preview',
            style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderEnabled.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                if (file != null && !isPdf)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: AppColors.grey.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  )
                else if (isPdf)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf_rounded,
                          color: AppColors.red,
                          size: 60,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'PDF Document',
                          style: TextStyle(
                            color: AppColors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      isPdf ? Icons.picture_as_pdf : Icons.image_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        fileName,
                        style: theme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () => controller.clearSelection(),
              icon: const Icon(Icons.close, size: 18, color: AppColors.error),
              label: Text(
                'Remove & Choose Another',
                style: theme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Spacer(),
          CustomButton(
            text: 'Analyze Document',
            height: 54,
            onTap: () => controller.analyzeDocument(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAnalyzingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              minHeight: 6,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              backgroundColor: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Analyzing document...',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This may take a moment.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    DecoderController controller,
  ) {
    final analysis = controller.analysisResult.value;
    if (analysis == null) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const .all(20),
            child: DecoderResultCard(analysis: analysis),
          ),
        ),
        Container(
          padding: const .fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const .only(
              topLeft: .circular(16),
              topRight: .circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.copy,
                      label: 'Copy All',
                      onTap: () => controller.copyAnalysisToClipboard(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.download_outlined,
                      label: 'Download',
                      onTap: () => controller.downloadAnalysis(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        text: 'Save to Records',
                        height: 46,
                        isLoading: controller.isSavingRecord.value,
                        buttonColor: AppColors.secondary,
                        onTap: () => _showSaveDialog(context, controller),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => controller.resetToInitial(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Analyze Another',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFailedState(BuildContext context, DecoderController controller) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Analysis Failed',
            style: theme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'Something went wrong. Please try again.',
              style: theme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Retry Analysis',
            height: 54,
            onTap: () => controller.retryAnalysis(),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => controller.clearSelection(),
            child: const Text(
              'Choose Another Document',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context, DecoderController controller) {
    final analysis = controller.analysisResult.value;
    if (analysis == null) return;

    final titleController = TextEditingController(
      text: 'Decoded ${analysis.documentTypeLabel}',
    );

    Get.bottomSheet(
      Material(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Save to Medical Records',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Text(
                'Choose a title for this record:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: titleController,
                hintText: "Document Title",
                textInputAction: .done,
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomButton(
                  text: 'Save',
                  height: 50,
                  isLoading: controller.isSavingRecord.value,
                  onTap: () async {
                    await controller.saveToMedicalRecords(
                      titleController.text.trim(),
                    );
                    Get.back();
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: AppColors.primary),
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
