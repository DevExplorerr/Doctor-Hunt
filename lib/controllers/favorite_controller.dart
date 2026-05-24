import 'package:doctor_hunt/data/repositories/favorite_repository.dart';
import 'package:get/get.dart';
import '../data/models/doctor_model.dart';
import '../presentation/widgets/feedback/app_snack_bar.dart';

class FavoriteController extends GetxController {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  var favoriteIds = <String>{}.obs;
  var favoriteDoctors = <DoctorModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  void clearFavoritesOnLogout() {
    favoriteIds.clear();
    favoriteDoctors.clear();
  }

  Future<void> fetchFavorites() async {
    if (_favoriteRepository.currentUserId == null) return;

    isLoading.value = true;
    try {
      final doctors = await _favoriteRepository.getFavorites();

      favoriteIds.clear();
      favoriteDoctors.clear();

      for (var doctor in doctors) {
        favoriteIds.add(doctor.id);
        favoriteDoctors.add(doctor);
      }
    } catch (e) {
      throw Exception("Error fetching favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(DoctorModel doctor) async {
    if (_favoriteRepository.currentUserId == null) {
      AppSnackBar.show(
        title: "Authentication",
        message: "Please log in to save favorites.",
        isError: true,
      );
      return;
    }

    final String docId = doctor.id;
    final bool isCurrentlyFavorite = favoriteIds.contains(docId);

    if (isCurrentlyFavorite) {
      favoriteIds.remove(docId);
      favoriteDoctors.removeWhere((d) => d.id == docId);
    } else {
      favoriteIds.add(docId);
      favoriteDoctors.add(doctor);
    }

    try {
      if (isCurrentlyFavorite) {
        await _favoriteRepository.removeFavorite(docId);
      } else {
        await _favoriteRepository.saveFavorite(doctor);
      }
    } catch (e) {
      if (isCurrentlyFavorite) {
        favoriteIds.add(docId);
        favoriteDoctors.add(doctor);
      } else {
        favoriteIds.remove(docId);
        favoriteDoctors.removeWhere((d) => d.id == docId);
      }
      AppSnackBar.show(
        title: "Error",
        message: "Could not update favorites. Check your connection.",
        isError: true,
      );
    }
  }

  bool isFavorite(String doctorId) => favoriteIds.contains(doctorId);
}
