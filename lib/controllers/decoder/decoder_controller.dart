import 'dart:io';

import 'package:doctor_hunt/data/models/decoder_response_model.dart';
import 'package:doctor_hunt/data/models/medical_record_model.dart';
import 'package:doctor_hunt/data/repositories/decoder_repository.dart';
import 'package:doctor_hunt/data/repositories/medical_record_repository.dart';
import 'package:doctor_hunt/data/services/decoder_pdf_generator.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

enum DecoderState { idle, fileSelected, analyzing, success, failed }

class DecoderController extends GetxController {
  final DecoderRepository _decoderRepo = DecoderRepository.instance;
  final MedicalRecordRepository _medicalRepo = MedicalRecordRepository.instance;
  final ImagePicker _picker = ImagePicker();

  var decoderState = DecoderState.idle.obs;
  var selectedFile = Rxn<File>();
  var selectedFileName = ''.obs;
  var uploadedImageUrl = RxnString();
  var analysisResult = Rxn<DecoderAnalysis>();
  var errorMessage = ''.obs;
  var isSavingRecord = false.obs;

  bool get isPdf => selectedFileName.value.toLowerCase().endsWith('.pdf');

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        selectedFile.value = File(photo.path);
        selectedFileName.value =
            "capture_${DateTime.now().millisecondsSinceEpoch}.jpg";
        uploadedImageUrl.value = null;
        analysisResult.value = null;
        decoderState.value = DecoderState.fileSelected;
      }
    } catch (e) {
      AppSnackBar.show(
        title: "Camera Error",
        message: "Failed to capture photo with device camera.",
        isError: true,
      );
    }
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
        selectedFileName.value = result.files.single.name;
        uploadedImageUrl.value = null;
        analysisResult.value = null;
        decoderState.value = DecoderState.fileSelected;
      }
    } catch (e) {
      AppSnackBar.show(
        title: "Error",
        message: "Could not pick image file.",
        isError: true,
      );
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
        selectedFileName.value = result.files.single.name;
        uploadedImageUrl.value = null;
        analysisResult.value = null;
        decoderState.value = DecoderState.fileSelected;
      }
    } catch (e) {
      AppSnackBar.show(
        title: "Error",
        message: "Could not pick file.",
        isError: true,
      );
    }
  }

  void clearSelection() {
    selectedFile.value = null;
    selectedFileName.value = '';
    uploadedImageUrl.value = null;
    analysisResult.value = null;
    errorMessage.value = '';
    decoderState.value = DecoderState.idle;
  }

  Future<void> analyzeDocument() async {
    final file = selectedFile.value;
    if (file == null) return;

    if (decoderState.value == DecoderState.analyzing) return;

    decoderState.value = DecoderState.analyzing;
    errorMessage.value = '';

    try {
      final ext = selectedFileName.value.split('.').last;
      final uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}.$ext";

      final imageUrl = await _medicalRepo.uploadRecordFile(
        file,
        uniqueFileName,
      );
      uploadedImageUrl.value = imageUrl;

      final result = await _decoderRepo.analyzeDocument(imageUrl);
      analysisResult.value = result;
      decoderState.value = DecoderState.success;
    } on DecoderException catch (e) {
      errorMessage.value = e.message;
      decoderState.value = DecoderState.failed;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      decoderState.value = DecoderState.failed;
    }
  }

  Future<void> retryAnalysis() async {
    if (uploadedImageUrl.value != null) {
      decoderState.value = DecoderState.analyzing;
      errorMessage.value = '';

      try {
        final result = await _decoderRepo.analyzeDocument(
          uploadedImageUrl.value!,
        );
        analysisResult.value = result;
        decoderState.value = DecoderState.success;
      } on DecoderException catch (e) {
        errorMessage.value = e.message;
        decoderState.value = DecoderState.failed;
      } catch (e) {
        errorMessage.value = 'An unexpected error occurred. Please try again.';
        decoderState.value = DecoderState.failed;
      }
    } else {
      await analyzeDocument();
    }
  }

  Future<void> saveToMedicalRecords(String title) async {
    final imageUrl = uploadedImageUrl.value;
    if (imageUrl == null) return;

    if (isSavingRecord.value) return;
    isSavingRecord.value = true;

    try {
      final analysis = analysisResult.value;
      final recordType = analysis != null
          ? analysis.documentTypeLabel
          : 'Document';

      final record = MedicalRecordModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.isNotEmpty ? title : 'Decoded Document',
        fileUrl: imageUrl,
        recordType: recordType,
        createdAt: DateTime.now(),
      );

      await _medicalRepo.saveRecordMetadata(record);

      AppSnackBar.show(
        title: "Saved",
        message: "Document saved to your medical records.",
      );
    } catch (e) {
      AppSnackBar.show(
        title: "Save Failed",
        message: "Could not save to medical records. Please try again.",
        isError: true,
      );
    } finally {
      isSavingRecord.value = false;
    }
  }

  void copyAnalysisToClipboard() {
    final analysis = analysisResult.value;
    if (analysis == null) return;

    final text = analysis.toMedicalContentText();
    Clipboard.setData(ClipboardData(text: text));

    AppSnackBar.show(
      title: "Copied",
      message: "Medical content copied to clipboard.",
    );
  }

  Future<void> downloadAnalysis() async {
    final analysis = analysisResult.value;
    if (analysis == null) return;

    try {
      final pdfFile = await DecoderPdfGenerator.generateAndSave(analysis);

      await SharePlus.instance.share(ShareParams(files: [XFile(pdfFile.path)]));
    } catch (e) {
      AppSnackBar.show(
        title: "Download Failed",
        message: "Could not generate the PDF. Please try again.",
        isError: true,
      );
    }
  }

  void resetToInitial() {
    selectedFile.value = null;
    selectedFileName.value = '';
    uploadedImageUrl.value = null;
    analysisResult.value = null;
    errorMessage.value = '';
    decoderState.value = DecoderState.idle;
  }
}
