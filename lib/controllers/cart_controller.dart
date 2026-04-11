import 'package:doctor_hunt/data/models/cart_item.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  var promoCode = ''.obs;
  var discount = 0.0.obs;

  // Add item to cart
  void addToCart(CartItem item) {
    int index = cartItems.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      cartItems[index].quantityCount++;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  void increaseQuantity(CartItem item) {
    int index = cartItems.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      cartItems[index].quantityCount++;
      cartItems.refresh();
    }
  }

  void decreaseQuantity(CartItem item) {
    int index = cartItems.indexWhere((i) => i.name == item.name);
    if (index != -1 && cartItems[index].quantityCount > 1) {
      cartItems[index].quantityCount--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    cartItems.refresh();
  }

  void clearCart() {
    cartItems.clear();
    discount.value = 0.0;
    promoCode.value = '';
  }

  // Apply promo code
  void applyPromoCode(String code) {
    promoCode.value = code;

    if (code.trim().toUpperCase() == 'SAVE10') {
      discount.value = totalPrice * 0.10;
    } else {
      discount.value = 0.0;
    }
  }

  // Getters for calculations
  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantityCount));

  double get tax => totalPrice * 0.10;

  double get shippingFee => cartItems.isNotEmpty ? 5.00 : 0.0;

  double get total => totalPrice + tax;

  double get totalWithShipping => total + shippingFee;

  double get totalWithPromo => totalWithShipping - discount.value;

  int get totalItems => cartItems.length;
}
