import 'package:doctor_hunt/data/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/doctor_repository.dart';

class HomeController extends GetxController {
  final DoctorRepository _repo = DoctorRepository.instance;
  late PageController pageController;

  var userName = "User".obs;
  var selectedIndex = 0.obs;
  var isLoading = false.obs;

  var popularDoctors = <DoctorModel>[].obs;
  var featureDoctors = <DoctorModel>[].obs;
  var liveDoctors = <DoctorModel>[].obs;

  var upcomingAppointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    getUserName();
    fetchUpcomingAppointments();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _repo.getPopularDoctors(),
        _repo.getFeatureDoctors(),
        _repo.getLiveDoctors(),
      ]);

      popularDoctors.assignAll(results[0]);
      featureDoctors.assignAll(results[1]);
      liveDoctors.assignAll(results[2]);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserName() async {
    try {
      final userData = await AuthRepository.instance.fetchUserName();

      if (userData != null) {
        userName.value = userData['name'] ?? "No Username";
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }

  void fetchUpcomingAppointments() async {
    upcomingAppointments.assignAll(await _repo.getUpcomingAppointments());
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
