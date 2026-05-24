import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/doctor_model.dart';

class FavoriteRepository {
  static FavoriteRepository get instance => FavoriteRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<List<DoctorModel>> getFavorites() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .get();

    return snapshot.docs
        .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> saveFavorite(DoctorModel doctor) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not logged in");

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(doctor.id)
        .set(doctor.toMap());
  }

  Future<void> removeFavorite(String doctorId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not logged in");

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(doctorId)
        .delete();
  }
}
