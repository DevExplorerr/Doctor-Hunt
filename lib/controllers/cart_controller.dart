import 'package:doctor_hunt/data/models/cart_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <CartModel>[].obs;

  var promoCode = ''.obs;
  var discount = 0.0.obs;

  void addToCart(CartModel item) {
    int index = cartItems.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      cartItems[index].quantityCount++;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  void removeFromCart(CartModel item) {
    cartItems.remove(item);
    cartItems.refresh();
  }

  void increaseQuantity(CartModel item) {
    int index = cartItems.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      cartItems[index].quantityCount++;
      cartItems.refresh();
    }
  }

  void decreaseQuantity(CartModel item) {
    int index = cartItems.indexWhere((i) => i.name == item.name);
    if (index != -1 && cartItems[index].quantityCount > 1) {
      cartItems[index].quantityCount--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  void clearCart() {
    cartItems.clear();
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

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantityCount));

  double get tax => totalPrice * 0.10;

  double get shippingFee => cartItems.isNotEmpty ? 5.00 : 0.0;

  double get total => totalPrice + tax;

  double get totalWithShipping => total + shippingFee;

  double get totalWithPromo => totalWithShipping - discount.value;

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantityCount);
  }
}
