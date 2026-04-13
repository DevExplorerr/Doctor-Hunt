import 'package:get/get.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/doctor_repository.dart';

class AllDoctorsController extends GetxController {
  final DoctorRepository _repo = DoctorRepository.instance;

  var doctorsList = <DoctorModel>[].obs;
  var isLoading = true.obs;
  String title = "All Doctors";

  @override
  void onInit() {
    super.onInit();
    loadFilteredData();
  }

  Future<void> loadFilteredData() async {
    try {
      isLoading.value = true;
      final args = Get.arguments;
      title = args?['title'] ?? "All Doctors";

      if (args?['type'] == 'popular') {
        var all = await _repo.getAllDoctors();
        all.sort((a, b) => b.rating.compareTo(a.rating));
        doctorsList.assignAll(all);
      } else if (args?['type'] == 'feature') {
        doctorsList.assignAll(await _repo.getFeatureDoctors());
      } else {
        doctorsList.assignAll(await _repo.getAllDoctors());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
