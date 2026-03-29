// ignore_for_file: deprecated_member_use

import 'package:doctor_app_ui/controller/cart_controller.dart';
import 'package:doctor_app_ui/presentation/screens/checkout/payment/add_card_screen.dart';
import 'package:doctor_app_ui/presentation/screens/checkout/address/address_screen.dart';
import 'package:doctor_app_ui/presentation/screens/checkout/order_succes_screen.dart';
import 'package:doctor_app_ui/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, String>? deliveryDetails;
  Map<String, String>? selectedCardDetails;
  final CartController cartController = Get.find();
  final TextEditingController promoCodeController = TextEditingController();
  String selectedPaymentMethod = "Credit Card";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, String>) {
        setState(() {
          deliveryDetails = args;
        });
      }
    });
  }

  void placeOrder() {
    if (deliveryDetails == null) {
      Get.snackbar(
        "Error",
        "Please enter delivery address",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 800),
        colorText: const Color(0xff000000),
        padding: const EdgeInsets.all(15),
        backgroundColor: const Color(0x000000ff),
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      );
      return;
    }

    if (selectedCardDetails == null) {
      Get.snackbar(
        "Error",
        "Please enter card details",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 800),
        colorText: const Color(0xff000000),
        padding: const EdgeInsets.all(15),
        backgroundColor: const Color(0x000000ff),
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      );
      return;
    }

    cartController.clearCart();
    Get.to(() => const OrderSuccesScreen());
  }

  Widget _buildAddressCard(Map<String, String> address) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${address['firstName']} ${address['lastName']}",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xff333333),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xff0EBE7F), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        address['address'] ?? '',
                        style: GoogleFonts.rubik(
                            fontSize: 14, color: const Color(0xff677294)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.markunread_mailbox,
                        color: Color(0xff0EBE7F), size: 18),
                    const SizedBox(width: 10),
                    Text(
                      address['postcode'] ?? '',
                      style: GoogleFonts.rubik(
                          fontSize: 14, color: const Color(0xff677294)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/bg/checkout_screen_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04),
                        child: TopSection(
                          text: "Checkout",
                          backButton:
                              const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Products List with limited height
                      SizedBox(
                        height: screenHeight * 0.3,
                        child: Obx(() {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: cartController.cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartController.cartItems[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.01,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(screenWidth * 0.03),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.16,
                                        height: screenWidth * 0.16,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff677294)
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: AssetImage(item.image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.05),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: GoogleFonts.rubik(
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.01),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$${item.price.toStringAsFixed(2)}",
                                                  style: GoogleFonts.rubik(
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    color:
                                                        const Color(0xff677294),
                                                  ),
                                                ),
                                                Text(
                                                  "Qty: ${item.quantityCount}",
                                                  style: GoogleFonts.rubik(
                                                      fontSize:
                                                          screenWidth * 0.035),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      // Bottom Section
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.015),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Delivery Address Section
                            Text(
                              "Delivery Address",
                              style: GoogleFonts.rubik(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),

                            deliveryDetails != null
                                ? _buildAddressCard(deliveryDetails!)
                                : Text(
                                    "No address provided",
                                    style: GoogleFonts.rubik(
                                        color: const Color(0xff677294)),
                                  ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddressScreen(
                                      initialAddress: deliveryDetails,
                                    ),
                                  ),
                                );
                                if (result != null &&
                                    result is Map<String, String>) {
                                  setState(() {
                                    deliveryDetails = result;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Color(0xff0EBE7F)),
                                    const SizedBox(width: 10),
                                    Text(
                                      deliveryDetails != null
                                          ? "Edit Address"
                                          : "Add Address",
                                      style: GoogleFonts.rubik(),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 16),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Promo Code Section
                            Text(
                              "Apply Promo Code",
                              style: GoogleFonts.rubik(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xffE0E0E0)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: TextField(
                                        cursorColor: const Color(0xff0EBE7F),
                                        controller: promoCodeController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter promo code",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff0EBE7F),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        cartController.applyPromoCode(
                                            promoCodeController.text.trim());
                                      },
                                      child: Text(
                                        "Apply",
                                        style: GoogleFonts.rubik(
                                            color: const Color(0xffFFFFFF)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Payment Method Section
                            Text(
                              "Payment Method",
                              style: GoogleFonts.rubik(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Get.to(
                                        () => const AddCardScreen());
                                    if (result != null) {
                                      setState(() {
                                        selectedCardDetails =
                                            Map<String, String>.from(result);
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.credit_card,
                                    color: Color(0xffffffff),
                                  ),
                                  label: Text(
                                    "Enter Card Details",
                                    style: GoogleFonts.rubik(
                                      color: const Color(0xffFFFFFF),
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff0EBE7F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.010),
                            if (selectedCardDetails != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  padding: EdgeInsets.all(screenWidth * 0.04),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.credit_card,
                                              color: Color(0xff0EBE7F)),
                                          SizedBox(width: screenWidth * 0.02),
                                          Expanded(
                                            child: Text(
                                              "Card: ${selectedCardDetails!['cardNumber']}",
                                              style: GoogleFonts.rubik(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.008),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              size: 18,
                                              color: Color(0xff0EBE7F)),
                                          SizedBox(width: screenWidth * 0.02),
                                          Expanded(
                                            child: Text(
                                              "Expiry: ${selectedCardDetails!['expiryDate']}",
                                              style: GoogleFonts.rubik(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.008),
                                      Row(
                                        children: [
                                          const Icon(Icons.person,
                                              color: Color(0xff0EBE7F)),
                                          SizedBox(width: screenWidth * 0.02),
                                          Expanded(
                                            child: Text(
                                              "Name: ${selectedCardDetails!['cardHolderName']}",
                                              style: GoogleFonts.rubik(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),

                            // Order Summary
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  style: GoogleFonts.rubik(
                                      fontSize: screenWidth * 0.04),
                                ),
                                Obx(
                                  () => Text(
                                    "\$${cartController.totalPrice.toStringAsFixed(2)}",
                                    style: GoogleFonts.rubik(
                                        fontSize: screenWidth * 0.04),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tax (10%)",
                                  style: GoogleFonts.rubik(
                                      fontSize: screenWidth * 0.04),
                                ),
                                Obx(
                                  () => Text(
                                    "\$${cartController.tax.toStringAsFixed(2)}",
                                    style: GoogleFonts.rubik(
                                        fontSize: screenWidth * 0.04),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shipping Fee",
                                  style: GoogleFonts.rubik(
                                      fontSize: screenWidth * 0.04),
                                ),
                                Obx(
                                  () => Text(
                                    "\$${cartController.shippingFee.toStringAsFixed(2)}",
                                    style: GoogleFonts.rubik(
                                        fontSize: screenWidth * 0.04),
                                  ),
                                ),
                              ],
                            ),
                            Obx(
                              () => cartController.discount > 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Promo Discount",
                                            style: GoogleFonts.rubik(
                                                fontSize: screenWidth * 0.04),
                                          ),
                                          Text(
                                            "-\$${cartController.discount.toStringAsFixed(2)}",
                                            style: GoogleFonts.rubik(
                                              fontSize: screenWidth * 0.04,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                            const Divider(color: Color(0xff677294)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Payment",
                                  style: GoogleFonts.rubik(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    "\$${cartController.totalWithPromo.toStringAsFixed(2)}",
                                    style: GoogleFonts.rubik(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff0EBE7F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Place Order Button
                            SizedBox(
                              width: double.infinity,
                              height: screenHeight * 0.06,
                              child: ElevatedButton(
                                onPressed: placeOrder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0EBE7F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Place Order",
                                  style: GoogleFonts.rubik(
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: screenHeight *
                                    0.03), // Extra bottom padding
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
