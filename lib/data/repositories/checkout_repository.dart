import 'package:cloud_firestore/cloud_firestore.dart';
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
}
