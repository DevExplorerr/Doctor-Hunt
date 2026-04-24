import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/doctor_model.dart';

class DoctorRepository extends GetxService {
  static DoctorRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<DoctorModel>> getPopularDoctors() async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .where('isPopular', isEqualTo: true)
          .limit(5)
          .get();
      return snapshot.docs.map((doc) => DoctorModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw "Could not fetch popular doctors: $e";
    }
  }

  Future<List<DoctorModel>> getFeatureDoctors() async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .where('isFeature', isEqualTo: true)
          .limit(5)
          .get();
      return snapshot.docs.map((doc) => DoctorModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw "Could not fetch featured doctors: $e";
    }
  }

  Future<List<DoctorModel>> getLiveDoctors() async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .where('isLive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => DoctorModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw "Could not fetch live doctors: $e";
    }
  }

  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final snapshot = await _db.collection('doctors').get();
      return snapshot.docs.map((doc) => DoctorModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw "Could not fetch doctor list: $e";
    }
  }

  Future<List<DoctorModel>> getDoctorsByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .where(
            'specialty',
            isEqualTo: category,
          )
          .get();
      return snapshot.docs.map((doc) => DoctorModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw "Could not fetch $category doctors: $e";
    }
  }
}
