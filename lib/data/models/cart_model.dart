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
}
