import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/data/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_hunt/data/models/order_model.dart';

class CheckoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  Future<bool> placeOrder(OrderModel order) async {
    if (uid == null) return false;

    try {
      WriteBatch batch = _firestore.batch();

      DocumentReference orderRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('orders')
          .doc();

      DocumentReference cartRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc('my_cart');

      batch.set(orderRef, order.toMap());
      batch.delete(cartRef);

      await batch.commit();

      return true;
    } catch (e) {
      throw Exception("Error placing order: $e");
    }
  }

  Stream<List<AddressModel>> getSavedAddresses() {
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc('my_addresses')
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) return [];
          final List items = snapshot.data()!['list'] ?? [];
          return items
              .map((e) => AddressModel.fromMap(e as Map<String, dynamic>))
              .toList();
        });
  }

  Future<void> saveAddress(AddressModel address) async {
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc('my_addresses')
        .set({
          'list': FieldValue.arrayUnion([address.toMap()]),
        }, SetOptions(merge: true));
  }

  Future<void> saveAllAddresses(List<AddressModel> addresses) async {
    if (uid == null) return;

    final List<Map<String, dynamic>> mappedAddresses = addresses
        .map((addr) => addr.toMap())
        .toList();

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc('my_addresses')
        .set({'list': mappedAddresses});
  }
}
