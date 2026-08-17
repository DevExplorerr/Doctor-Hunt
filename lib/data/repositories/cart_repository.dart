import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/data/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get uid => _auth.currentUser?.uid;

  Stream<List<CartModel>> getCartStream() {
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc('my_cart')
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) return [];

          final data = snapshot.data()!;
          final List items = data['items'] ?? [];

          return items
              .map((e) => CartModel.fromMap(e as Map<String, dynamic>))
              .toList();
        });
  }

  Future<void> saveCart(List<CartModel> items) async {
    if (uid == null) return;

    final List<Map<String, dynamic>> mappedItems = items
        .map((item) => item.toMap())
        .toList();

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc('my_cart')
        .set({'items': mappedItems});
  }
}
