import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/data/models/cart_model.dart';
import 'package:doctor_hunt/data/models/order_model.dart';
import 'package:doctor_hunt/data/repositories/checkout_repository.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/order_succes_screen.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final CheckoutRepository _repository = CheckoutRepository();
  final CartController _cartController = Get.find<CartController>();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController promoController = TextEditingController();

  var isProcessing = false.obs;
  var discountAmount = 0.0.obs;
  var selectedPaymentMethod = 'COD'.obs;

  final double taxRate = 0.05;
  final double shippingFee = 10.00;

  List<CartModel> get cartItems => _cartController.cartItems;
  double get subTotal => _cartController.totalPrice;
  double get taxAmount => subTotal * taxRate;
  double get grandTotal =>
      (subTotal + taxAmount + shippingFee) - discountAmount.value;

  void applyPromoCode() {
    if (promoController.text.trim().toUpperCase() == 'SAVE10') {
      discountAmount.value = subTotal * 0.10;
    } else {
      discountAmount.value = 0.0;
      AppSnackBar.show(
        title: 'Error',
        message: 'Invalid promo code',
        isError: true,
      );
    }
  }

  Future<void> placeOrder() async {
    if (addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      AppSnackBar.show(
        title: 'Required',
        message: 'Please enter shipping details',
        isError: true,
      );
      return;
    }

    if (_cartController.cartItems.isEmpty) return;

    isProcessing.value = true;

    final newOrder = OrderModel(
      address: addressController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      subTotal: subTotal,
      tax: taxAmount,
      shippingFee: shippingFee,
      discount: discountAmount.value,
      grandTotal: grandTotal,
      paymentMethod: selectedPaymentMethod.value,
      items: _cartController.cartItems.toList(),
      orderDate: DateTime.now(),
    );

    bool success = await _repository.placeOrder(newOrder);

    isProcessing.value = false;

    if (success) {
      _cartController.cartItems.clear();

      Get.to(() => const OrderSuccesScreen());
      AppSnackBar.show(
        title: 'Order Placed!',
        message: 'Your order has been placed successfully.',
      );
    } else {
      AppSnackBar.show(
        title: 'Error',
        message: 'Failed to place order. Please try again.',
        isError: true,
      );
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    phoneController.dispose();
    promoController.dispose();
    super.onClose();
  }
}
