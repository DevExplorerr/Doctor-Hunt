import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/data/models/cart_model.dart';

class OrderModel {
  final String? id;
  final String address;
  final String phoneNumber;
  final double subTotal;
  final double tax;
  final double shippingFee;
  final double discount;
  final double grandTotal;
  final String paymentMethod;
  final List<CartModel> items;
  final DateTime orderDate;
  final String status;

  OrderModel({
    this.id,
    required this.address,
    required this.phoneNumber,
    required this.subTotal,
    required this.tax,
    required this.shippingFee,
    required this.discount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.items,
    required this.orderDate,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'phoneNumber': phoneNumber,
      'subTotal': subTotal,
      'tax': tax,
      'shippingFee': shippingFee,
      'discount': discount,
      'grandTotal': grandTotal,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => item.toMap()).toList(),
      'orderDate': Timestamp.fromDate(orderDate),
      'status': status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      subTotal: (map['subTotal'] ?? 0.0).toDouble(),
      tax: (map['tax'] ?? 0.0).toDouble(),
      shippingFee: (map['shippingFee'] ?? 0.0).toDouble(),
      discount: (map['discount'] ?? 0.0).toDouble(),
      grandTotal: (map['grandTotal'] ?? 0.0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? 'COD',
      items:
          (map['items'] as List<dynamic>?)
              ?.map((item) => CartModel.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      status: map['status'] ?? 'Pending',
    );
  }
}
