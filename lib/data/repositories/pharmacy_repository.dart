import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/data/models/pharmacy_model.dart';

class PharmacyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PharmacyModel>> getAllMedicines() async {
    final QuerySnapshot snapshot = await _firestore
        .collection('medicines')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => PharmacyModel.fromFirestore(doc))
        .toList();
  }
}
