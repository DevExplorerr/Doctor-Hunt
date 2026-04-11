class CartItem {
  String name;
  double price;
  String image;
  int quantityCount;
  bool isSelected;

  CartItem(
      {required this.name,
      required this.price,
      required this.image,
      this.quantityCount = 1, 
      this.isSelected = false});
}
