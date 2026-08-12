import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyModel {
  final String id;
  final String name;
  final String desciption;
  final String category;
  final String quantity;
  final double price;
  final String image;
  final bool isActive;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.desciption,
    required this.category,
    required this.quantity,
    required this.price,
    required this.image,
    this.isActive = true,
  });

  factory PharmacyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PharmacyModel(
      id: doc.id,
      name: data['name'] ?? '',
      desciption: data['description'] ?? '',
      category: data['category'] ?? '',
      quantity: data['quantity'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      image: data['image'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }
}
