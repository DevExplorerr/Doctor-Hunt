import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/data/models/pharmacy_model.dart';

class PharmacyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PharmacyModel>> getMedicinesByCategory(
    String category, {
    int? limit,
  }) async {
    Query query = _firestore
        .collection('medicines')
        .where('isActive', isEqualTo: true)
        .where('category', isEqualTo: category);

    if (limit != null) {
      query = query.limit(limit);
    }

    final QuerySnapshot snapshot = await query.get();

    return snapshot.docs
        .map((doc) => PharmacyModel.fromFirestore(doc))
        .toList();
  }

  Future<List<PharmacyModel>> getAllMedicinesForSearch() async {
    final QuerySnapshot snapshot = await _firestore
        .collection('medicines')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => PharmacyModel.fromFirestore(doc))
        .toList();
  }
}
