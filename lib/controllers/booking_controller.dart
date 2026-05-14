// lib/controllers/booking_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/doctor_model.dart';
import '../data/repositories/doctor_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingController extends GetxController {
  final DoctorRepository _repo = DoctorRepository.instance;

  var selectedDoctor = Rxn<DoctorModel>();
  var availableSlots = <String>[].obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = "".obs;
  var isLoading = false.obs;

  void startBooking(DoctorModel doctor) {
    selectedDoctor.value = doctor;
    fetchSlots(doctor.id);
    Get.toNamed('/select-time');
  }

  void fetchSlots(String doctorId) async {
    isLoading.value = true;
    try {
      final slots = await _repo.getDoctorTimeSlots(doctorId);
      availableSlots.assignAll(slots);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmBooking() async {
    if (selectedTime.isEmpty) {
      Get.snackbar("Error", "Please select a time slot");
      return;
    }

    isLoading.value = true;
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      Map<String, dynamic> appointment = {
        'doctorId': selectedDoctor.value!.id,
        'doctorName': selectedDoctor.value!.name,
        'date': selectedDate.value.toIso8601String(),
        'time': selectedTime.value,
        'status': 'upcoming',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _repo.saveAppointment(uid, appointment);
      Get.offAllNamed('/thank-you');
    } catch (e) {
      Get.snackbar("Booking Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
