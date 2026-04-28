import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/doctor_model.dart';

class DoctorRepository extends GetxService {
  static DoctorRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<DoctorModel>> getPopularDoctors() async =>
      _fetchSimple('isPopular', true, 5);
  Future<List<DoctorModel>> getFeatureDoctors() async =>
      _fetchSimple('isFeature', true, 5);
  Future<List<DoctorModel>> getLiveDoctors() async =>
      _fetchSimple('isLive', true);

  Future<List<DoctorModel>> _fetchSimple(
    String field,
    dynamic value, [
    int? limit,
  ]) async {
    try {
      Query query = _db.collection('doctors').where(field, isEqualTo: value);
      if (limit != null) query = query.limit(limit);
      final snapshot = await query.get();
      return snapshot.docs
          .map(
            (doc) => DoctorModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      throw "Fetch Error ($field): $e";
    }
  }

  Future<Map<String, dynamic>> getAllDoctors({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    String? type,
  }) async {
    try {
      Query query = _db.collection('doctors');

      if (type == 'popular') {
        query = query.where('isPopular', isEqualTo: true);
      } else if (type == 'feature') {
        query = query.where('isFeature', isEqualTo: true);
      }

      query = query.orderBy('name');

      if (lastDocument != null) query = query.startAfterDocument(lastDocument);
      query = query.limit(limit);

      final snapshot = await query.get();
      final doctors = snapshot.docs
          .map(
            (doc) => DoctorModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();

      return {
        'doctors': doctors,
        'lastDocument': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      };
    } catch (e) {
      throw "Could not fetch doctors list.";
    }
  }

  Future<List<DoctorModel>> getDoctorsByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .where('specialty', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => DoctorModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw "Could not fetch $category doctors.";
    }
  }
}
