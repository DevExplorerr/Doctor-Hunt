import 'package:doctor_hunt/data/models/cart_model.dart';
import 'package:doctor_hunt/data/repositories/cart_repository.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartRepository _repository = CartRepository();

  var cartItems = <CartModel>[].obs;

  var promoCode = ''.obs;
  var discount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    cartItems.bindStream(_repository.getCartStream());
  }

  void addToCart(CartModel item) {
    var existingItem = cartItems.firstWhereOrNull((e) => e.name == item.name);

    if (existingItem != null) {
      int newQuantity = existingItem.quantityCount + item.quantityCount;
      _repository.updateQuantity(item.name, newQuantity);
    } else {
      _repository.addToCart(item);
    }
  }

  void removeFromCart(CartModel item) {
    _repository.removeFromCart(item.name);
  }

  void increaseQuantity(CartModel item) {
    _repository.updateQuantity(item.name, item.quantityCount + 1);
  }

  void decreaseQuantity(CartModel item) {
    if (item.quantityCount > 1) {
      _repository.updateQuantity(item.name, item.quantityCount - 1);
    }
  }

  void clearCart() {
    _repository.clearCart(cartItems.toList());
    discount.value = 0.0;
    promoCode.value = '';
  }

    void applyPromoCode(String code) {
    promoCode.value = code;

    if (code.trim().toUpperCase() == 'SAVE10') {
      discount.value = totalPrice * 0.10;
    } else {
      discount.value = 0.0;
    }
  }

  double get tax => totalPrice * 0.10;
  double get shippingFee => cartItems.isNotEmpty ? 5.00 : 0.0;

  double get total => totalPrice + tax;

  double get totalWithShipping => total + shippingFee;

  double get totalWithPromo => totalWithShipping - discount.value;

  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantityCount),
    );
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantityCount);
  }
}
