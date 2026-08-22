import 'dart:io';
import 'package:doctor_hunt/data/models/medical_record_model.dart';
import 'package:doctor_hunt/data/repositories/medical_record_repository.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MedicalRecordController extends GetxController {
  final MedicalRecordRepository _repo = MedicalRecordRepository.instance;
  final ImagePicker _picker = ImagePicker();

  var records = <MedicalRecordModel>[].obs;
  var isLoading = false.obs;
  var isUploading = false.obs;
  var selectedRecordType = 'Prescription'.obs;

  late TextEditingController titleController;
  late TextEditingController doctorNameController;

  var selectedFile = Rxn<File>();
  var selectedFileName = "".obs;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    doctorNameController = TextEditingController();
    fetchRecords();
  }

  @override
  void onClose() {
    titleController.dispose();
    doctorNameController.dispose();
    super.onClose();
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
      }
    } catch (e) {
      AppSnackBar.show(
        title: "Error",
        message: "Could not pick file",
        isError: true,
      );
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        selectedFile.value = File(photo.path);
        selectedFileName.value =
            "camera_capture_${DateTime.now().millisecondsSinceEpoch}.jpg";
      }
    } catch (e) {
      AppSnackBar.show(
        title: "Camera Error",
        message: "Failed to initialize or capture photo with device hardware",
        isError: true,
      );
    }
  }

  void clearSelection() {
    selectedFile.value = null;
    selectedFileName.value = "";
    selectedRecordType.value = "Prescription";
  }

  Future<void> fetchRecords() async {
    isLoading.value = true;
    try {
      records.value = await _repo.fetchRecords();
    } catch (e) {
      AppSnackBar.show(
        title: "Error",
        message: "Could not load medical records",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveRecord() async {
    final title = titleController.text.trim();
    final doctor = doctorNameController.text.trim();

    if (title.isEmpty || doctor.isEmpty || selectedFile.value == null) {
      AppSnackBar.show(
        title: "Required",
        message: "Please fill all fields and select a file",
        isError: true,
      );
      return false;
    }

    isUploading.value = true;
    try {
      final fileExtension = selectedFileName.value.split('.').last;
      final uniqueFileName =
          "${DateTime.now().millisecondsSinceEpoch}.$fileExtension";

      final fileUrl = await _repo.uploadRecordFile(
        selectedFile.value!,
        uniqueFileName,
      );

      final newRecord = MedicalRecordModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        doctorName: doctor.isEmpty ? "General Doctor" : doctor,
        fileUrl: fileUrl,
        recordType: selectedRecordType.value,
        createdAt: DateTime.now(),
      );

      await _repo.saveRecordMetadata(newRecord);

      records.insert(0, newRecord);
      titleController.clear();
      doctorNameController.clear();
      clearSelection();

      return true;
    } catch (e) {
      AppSnackBar.show(
        title: "Upload Failed",
        message: e.toString(),
        isError: true,
      );
      return false;
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await _repo.deleteRecord(recordId);

      records.removeWhere((record) => record.id == recordId);

      AppSnackBar.show(
        title: "Success",
        message: "Record deleted successfully",
      );
    } catch (e) {
      AppSnackBar.show(
        title: "Error",
        message: "Failed to delete record",
        isError: true,
      );
    }
  }
}
