class CartModel {
  String name;
  double price;
  String image;
  int quantityCount;

  CartModel({
    required this.name,
    required this.price,
    required this.image,
    this.quantityCount = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'quantityCount': quantityCount,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      image: map['image'] ?? '',
      quantityCount: map['quantityCount']?.toInt() ?? 1,
    );
  }
}
