import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxService {
  final DoctorRepository _repo = DoctorRepository.instance;

  var isLoading = false.obs;

  var upcomingAppointments = <Map<String, dynamic>>[].obs;
  var completedAppointments = <Map<String, dynamic>>[].obs;
  var canceledAppointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllAppointments();
  }

  Future<void> fetchAllAppointments() async {
    isLoading.value = true;
    try {
      final allAppointments = await _repo.getUserAppointments();

      upcomingAppointments.clear();
      completedAppointments.clear();
      canceledAppointments.clear();

      final now = DateTime.now();

      for (var appt in allAppointments) {
        String status = appt['status'] ?? 'upcoming';

        if (status == 'upcoming') {
          try {
            DateTime apptDate = DateTime.parse(appt['date']);
            if (apptDate.isBefore(DateTime(now.year, now.month, now.day))) {
              completedAppointments.add(appt);
              continue;
            }
          } catch (_) {}
          upcomingAppointments.add(appt);
        } else if (status == 'completed') {
          completedAppointments.add(appt);
        } else if (status == 'canceled') {
          canceledAppointments.add(appt);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    isLoading.value = true;
    bool success = await _repo.updateAppointmentStatus(
      appointmentId,
      'canceled',
    );

    if (success) {
      final apptIndex = upcomingAppointments.indexWhere(
        (a) => a['id'] == appointmentId,
      );
      if (apptIndex != -1) {
        var canceledAppt = upcomingAppointments.removeAt(apptIndex);
        canceledAppt['status'] = 'canceled';
        canceledAppointments.insert(0, canceledAppt);
      }

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchUpcomingAppointments();
      }

      AppSnackBar.show(
        title: "Canceled",
        message: "Appointment canceled successfully",
      );
    } else {
      AppSnackBar.show(
        title: "Error",
        message: "Failed to cancel appointment",
        isError: true,
      );
    }
    isLoading.value = false;
  }

  Future<void> initiateReschedule(
    String doctorId,
    String oldAppointmentId,
  ) async {
    isLoading.value = true;
    try {
      final doctor = await _repo.getDoctorById(doctorId);

      final bookingController = Get.put(BookingController());

      bookingController.startBooking(
        doctor,
        oldAppointmentId: oldAppointmentId,
      );
    } catch (e) {
      AppSnackBar.show(
        title: "Error",
        message: "Could not load doctor for rescheduling",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
