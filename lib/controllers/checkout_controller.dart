import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/data/models/address_model.dart';
import 'package:doctor_hunt/data/models/cart_model.dart';
import 'package:doctor_hunt/data/models/order_model.dart';
import 'package:doctor_hunt/data/repositories/checkout_repository.dart';
import 'package:doctor_hunt/presentation/screens/medicine_orders/checkout/add_address_screen.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final CheckoutRepository _repository = CheckoutRepository();
  final CartController _cartController = Get.find<CartController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController promoController = TextEditingController();

  var isProcessing = false.obs;
  var discountAmount = 0.0.obs;
  var selectedPaymentMethod = 'COD'.obs;
  var isSavingAddress = false.obs;

  var savedAddresses = <AddressModel>[].obs;
  var selectedAddress = Rxn<AddressModel>();

  AddressModel? addressBeingEdited;

  final double taxRate = 0.05;
  final double shippingFee = 10.00;

  late final List<CartModel> checkoutItems;
  late final double checkoutSubTotal;

  List<CartModel> get cartItems => checkoutItems;
  double get subTotal => checkoutSubTotal;

  double get taxAmount => subTotal * taxRate;
  double get grandTotal =>
      (subTotal + taxAmount + shippingFee) - discountAmount.value;

  @override
  void onInit() {
    super.onInit();
    checkoutItems = List.from(_cartController.cartItems);
    checkoutSubTotal = _cartController.totalPrice;
    savedAddresses.bindStream(_repository.getSavedAddresses());
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
    nameController.text = address.name;
    addressController.text = address.address;
    phoneController.text = address.phoneNumber;
  }

  Future<bool> saveNewAddress() async {
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      AppSnackBar.show(
        title: 'Required',
        message: 'Enter details to save.',
        isError: true,
      );
      return false;
    }

    isSavingAddress.value = true;

    final newAddress = AddressModel(
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      phoneNumber: phoneController.text.trim(),
    );

    List<AddressModel> updatedList = List.from(savedAddresses);

    if (addressBeingEdited != null) {
      int index = updatedList.indexOf(addressBeingEdited!);
      if (index != -1) {
        updatedList[index] = newAddress;
      }
      addressBeingEdited = null;
    } else {
      updatedList.add(newAddress);
    }

    await _repository.saveAllAddresses(updatedList);
    selectAddress(newAddress);
    isSavingAddress.value = false;
    return true;
  }

  void deleteAddress(AddressModel address) {
    savedAddresses.remove(address);
    if (selectedAddress.value == address) {
      selectedAddress.value = null;
    }
    _repository.saveAllAddresses(savedAddresses.toList());
  }

  void editAddress(AddressModel address) {
    addressBeingEdited = address;

    nameController.text = address.name;
    addressController.text = address.address;
    phoneController.text = address.phoneNumber;

    Get.to(() => const AddAddressScreen());
  }

  void applyPromoCode() {
    if (promoController.text.trim().toUpperCase() == 'SAVE10') {
      discountAmount.value = subTotal * 0.10;
      AppSnackBar.show(title: 'Success', message: 'Promo code applied!');
    } else {
      discountAmount.value = 0.0;
      AppSnackBar.show(
        title: 'Error',
        message: 'Invalid promo code',
        isError: true,
      );
    }
  }

  Future<bool> placeOrder() async {
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      AppSnackBar.show(
        title: 'Required',
        message: 'Please add/select shipping details',
        isError: true,
      );
      return false;
    }

    if (checkoutItems.isEmpty) return false;

    isProcessing.value = true;

    final newOrder = OrderModel(
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      subTotal: subTotal,
      tax: taxAmount,
      shippingFee: shippingFee,
      discount: discountAmount.value,
      grandTotal: grandTotal,
      paymentMethod: selectedPaymentMethod.value,
      items: checkoutItems,
      orderDate: DateTime.now(),
    );

    bool success = await _repository.placeOrder(newOrder);

    isProcessing.value = false;

    if (success) {
      return true;
    } else {
      AppSnackBar.show(
        title: 'Error',
        message: 'Failed to place order. Please try again.',
        isError: true,
      );
      return false;
    }
  }

  void clearLocalCart() {
    _cartController.cartItems.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    promoController.dispose();
    super.onClose();
  }
}
