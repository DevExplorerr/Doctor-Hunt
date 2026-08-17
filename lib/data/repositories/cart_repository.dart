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
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CartModel.fromMap(doc.data()))
              .toList();
        });
  }

  Future<void> addToCart(CartModel item) async {
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(item.name)
        .set(item.toMap());
  }

  Future<void> updateQuantity(String itemName, int newQuantity) async {
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(itemName)
        .update({'quantityCount': newQuantity});
  }

  Future<void> removeFromCart(String itemName) async {
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(itemName)
        .delete();
  }

  Future<void> clearCart(List<CartModel> currentItems) async {
    if (uid == null) return;

    WriteBatch batch = _firestore.batch();
    for (var item in currentItems) {
      var docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(item.name);
      batch.delete(docRef);
    }
    await batch.commit();
  }
}
