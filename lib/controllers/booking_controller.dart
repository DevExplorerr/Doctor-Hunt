import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/doctor_model.dart';
import '../data/repositories/doctor_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingController extends GetxController {
  final DoctorRepository _repo = DoctorRepository.instance;

  final selectedDoctor = Rxn<DoctorModel>();
  final availableSlots = <String>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = "".obs;
  final isLoading = false.obs;

  final masterAfternoonSlots = <String>[].obs;
  final masterEveningSlots = <String>[].obs;

  List<DateTime> get upcomingDays =>
      List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

  void startBooking(DoctorModel doctor) {
    selectedDoctor.value = doctor;
    selectedDate.value = DateTime.now();
    selectedTime.value = "";
    fetchSlots(doctor.id);
    Get.toNamed('/select-time');
  }

  bool _isSlotBlocked(String slot, int dayOfWeek) {
    if (dayOfWeek == 1 && (slot.contains("02:00") || slot.contains("06:30"))) {
      return true;
    }
    if (dayOfWeek == 2 && (slot.contains("01:30") || slot.contains("05:00"))) {
      return true;
    }
    if (dayOfWeek == 3 && (slot.contains("03:00") || slot.contains("07:00"))) {
      return true;
    }
    if (dayOfWeek == 4 && (slot.contains("04:00") || slot.contains("06:00"))) {
      return true;
    }
    if (dayOfWeek == 5 && (slot.contains("02:30") || slot.contains("08:00"))) {
      return true;
    }
    if (dayOfWeek == 6 &&
        (slot.contains("01:00") ||
            slot.contains("03:30") ||
            slot.contains("05:30") ||
            slot.contains("07:30"))) {
      return true;
    }
    return false;
  }

  List<String> get afternoonSlots {
    int dayOfWeek = selectedDate.value.weekday;
    if (dayOfWeek == 7) return [];
    return masterAfternoonSlots
        .where((slot) => !_isSlotBlocked(slot, dayOfWeek))
        .toList();
  }

  List<String> get eveningSlots {
    int dayOfWeek = selectedDate.value.weekday;
    if (dayOfWeek == 7) return [];
    return masterEveningSlots
        .where((slot) => !_isSlotBlocked(slot, dayOfWeek))
        .toList();
  }

  void fetchSlots(String doctorId) async {
    isLoading.value = true;
    try {
      final slots = await _repo.getDoctorTimeSlots(doctorId);
      availableSlots.assignAll(slots);

      List<String> afternoon = [];
      List<String> evening = [];

      for (var slot in slots) {
        if (slot.contains("PM") &&
            (slot.startsWith("01") ||
                slot.startsWith("02") ||
                slot.startsWith("03") ||
                slot.startsWith("04"))) {
          afternoon.add(slot);
        } else {
          evening.add(slot);
        }
      }

      final DateFormat timeFormat = DateFormat("hh:mm a");
      afternoon.sort(
        (a, b) => timeFormat.parse(a).compareTo(timeFormat.parse(b)),
      );
      evening.sort(
        (a, b) => timeFormat.parse(a).compareTo(timeFormat.parse(b)),
      );

      masterAfternoonSlots.assignAll(afternoon);
      masterEveningSlots.assignAll(evening);
    } catch (e) {
      Get.snackbar("Error", "Could not fetch slots: $e");
    } finally {
      isLoading.value = false;
    }
  }

  int getAvailableSlotsCountForDate(DateTime date) {
    int dayOfWeek = date.weekday;
    if (dayOfWeek == 7) return 0;

    int afternoonCount = masterAfternoonSlots
        .where((slot) => !_isSlotBlocked(slot, dayOfWeek))
        .length;
    int eveningCount = masterEveningSlots
        .where((slot) => !_isSlotBlocked(slot, dayOfWeek))
        .length;

    return afternoonCount + eveningCount;
  }

  String getNextAvailableSlotText(DoctorModel doctor) {
    final String specialty = doctor.specialty.toLowerCase();
    final DateFormat labelFormat = DateFormat("d MMM");

    List<String> shiftAfternoon = [];
    List<String> shiftEvening = [];

    if (specialty.contains("dentist") || specialty.contains("psychologist")) {
      shiftAfternoon = ["01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM"];
      shiftEvening = ["05:00 PM", "06:00 PM", "07:00 PM"];
    } else if (specialty.contains("surgeon") ||
        specialty.contains("orthopedic") ||
        specialty.contains("cardiologist") ||
        specialty.contains("neurologist")) {
      shiftAfternoon = ["02:00 PM", "02:45 PM", "03:30 PM", "04:15 PM"];
      shiftEvening = [
        "05:30 PM",
        "06:15 PM",
        "07:00 PM",
        "07:45 PM",
        "08:30 PM",
      ];
    } else {
      shiftAfternoon = [
        "01:00 PM",
        "01:30 PM",
        "02:00 PM",
        "02:30 PM",
        "03:00 PM",
        "03:30 PM",
        "04:00 PM",
      ];
      shiftEvening = [
        "05:00 PM",
        "05:30 PM",
        "06:00 PM",
        "06:30 PM",
        "07:00 PM",
        "07:30 PM",
        "08:00 PM",
      ];
    }

    for (int index = 0; index < upcomingDays.length; index++) {
      DateTime day = upcomingDays[index];
      int dayOfWeek = day.weekday;

      if (dayOfWeek == 7) continue;

      List<String> validAfternoon = shiftAfternoon
          .where((slot) => !_isSlotBlocked(slot, dayOfWeek))
          .toList();
      List<String> validEvening = shiftEvening
          .where((slot) => !_isSlotBlocked(slot, dayOfWeek))
          .toList();

      String dayWord = index == 0
          ? "today"
          : (index == 1 ? "tomorrow" : "on ${labelFormat.format(day)}");

      if (validAfternoon.isNotEmpty) return "${validAfternoon.first} $dayWord";
      if (validEvening.isNotEmpty) return "${validEvening.first} $dayWord";
    }

    return "No slots this week";
  }

  Future<void> confirmBooking() async {
    if (selectedTime.isEmpty) {
      AppSnackBar.show(
        title: "Error",
        message: "Please select a time slot",
        isError: true,
      );
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
      AppSnackBar.show(title: "Booking Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
