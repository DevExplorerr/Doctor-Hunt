// ignore_for_file: deprecated_member_use

import 'package:doctor_app_ui/presentation/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doctor_app_ui/controller/cart_controller.dart';
import 'package:doctor_app_ui/presentation/widgets/header/top_section.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 375;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg/cart_screen_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: isSmallScreen ? 30 : 50),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24),
                child: TopSection(
                  text: "My Cart",
                  backButton:
                      Icon(Icons.arrow_back_ios, size: isSmallScreen ? 18 : 20),
                  onPressed: () => Get.back(),
                  iconButton: IconButton(
                    onPressed: () {
                      if (cartController.cartItems.isEmpty) {
                        Get.snackbar(
                            "Cart Empty", "Your cart is already empty.",
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(milliseconds: 800));
                      } else {
                        cartController.clearCart();
                        Get.snackbar(
                          "Cart Cleared",
                          "All items have been removed from the cart.",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(milliseconds: 800),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete, color: Color(0xffFB0000)),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 10 : 15),
              Expanded(
                child: Obx(() {
                  if (cartController.cartItems.isEmpty) {
                    return Center(
                      child: Text("Your cart is empty",
                          style: GoogleFonts.rubik(
                            fontSize: isSmallScreen ? 16 : 18,
                          )),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: isSmallScreen ? 80 : 100),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 24,
                          vertical: isSmallScreen ? 8 : 12,
                        ),
                        child: Dismissible(
                          key: Key(item.name),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding:
                                EdgeInsets.only(right: isSmallScreen ? 16 : 24),
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete,
                                color: Color(0xff0EBE7F)),
                          ),
                          onDismissed: (direction) {
                            cartController.removeFromCart(item);
                          },
                          child: Container(
                            height: isSmallScreen ? 80 : 100,
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Product Image
                                Container(
                                  width: isSmallScreen ? 60 : 70,
                                  height: isSmallScreen ? 60 : 70,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff677294)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(item.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 12 : 16),

                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.name,
                                        style: GoogleFonts.rubik(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff000000),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: isSmallScreen ? 4 : 6),
                                      Text(
                                        "\$${item.price.toStringAsFixed(2)}",
                                        style: GoogleFonts.rubik(
                                          fontSize: isSmallScreen ? 13 : 14,
                                          color: const Color(0xff677294),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Quantity Controls
                                Row(
                                  children: [
                                    _buildQuantityButton(
                                      context,
                                      icon: Icons.remove,
                                      onPressed: () =>
                                          cartController.decreaseQuantity(item),
                                      isSmallScreen: isSmallScreen,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    SizedBox(
                                      width: isSmallScreen ? 24 : 30,
                                      child: Center(
                                        child: Text(
                                          "${item.quantityCount}",
                                          style: GoogleFonts.rubik(
                                            fontSize: isSmallScreen ? 14 : 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    _buildQuantityButton(
                                      context,
                                      icon: Icons.add,
                                      onPressed: () =>
                                          cartController.increaseQuantity(item),
                                      isSmallScreen: isSmallScreen,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),

          // Bottom Summary Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: isSmallScreen ? 12 : 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSmallScreen ? 16 : 20),
                  topRight: Radius.circular(isSmallScreen ? 16 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => Column(
                        children: [
                          _buildPriceRow(
                            "Sub Total",
                            "\$${cartController.totalPrice.toStringAsFixed(2)} USD",
                            isSmallScreen,
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          _buildPriceRow(
                            "Tax (10%)",
                            "\$${cartController.tax.toStringAsFixed(2)} USD",
                            isSmallScreen,
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          _buildPriceRow(
                            "Total:",
                            "\$${(cartController.total).toStringAsFixed(2)} USD",
                            isSmallScreen,
                            isTotal: true,
                          ),
                        ],
                      )),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  SizedBox(
                    height: isSmallScreen ? 48 : 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 12 : 16),
                        ),
                        backgroundColor: const Color(0xff0ebe7f),
                      ),
                      onPressed: () {
                        if (cartController.cartItems.isEmpty) {
                          Get.snackbar(
                            "Cart is Empty",
                            "Please add item to cart",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.to(() => const CheckoutScreen());
                        }
                      },
                      child: Text(
                        "Checkout",
                        style: GoogleFonts.rubik(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required bool isSmallScreen,
  }) {
    return Container(
      width: isSmallScreen ? 28 : 32,
      height: isSmallScreen ? 28 : 32,
      decoration: BoxDecoration(
        color: const Color(0xff677294).withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: const Color(0xff000000),
          size: isSmallScreen ? 16 : 18,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, bool isSmallScreen,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: isSmallScreen ? 14 : 16,
            color: const Color(0xff000000),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.rubik(
            fontSize: isSmallScreen ? 14 : 16,
            color: isTotal ? const Color(0xff0EBE7F) : const Color(0xff000000),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
