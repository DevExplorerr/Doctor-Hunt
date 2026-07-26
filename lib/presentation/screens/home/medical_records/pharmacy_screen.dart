// ignore_for_file: deprecated_member_use

import 'package:doctor_hunt/controllers/cart_controller.dart';
import 'package:doctor_hunt/data/models/cart_item.dart';
import 'package:doctor_hunt/presentation/screens/cart/cart_screen.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:doctor_hunt/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/medicine_screen/medicine_screen_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: TopSection(
                  text: "Pharmacy",
                  textStyle: GoogleFonts.rubik(
                    color: const Color(0xff333333),
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w500,
                  ),
                  iconButton: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_sharp),
                        onPressed: () {
                          Get.to(() => const CartScreen());
                        },
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Obx(() => cartController.totalItems > 0
                            ? CircleAvatar(
                                radius: 10,
                                backgroundColor: const Color(0xff0EBE7F),
                                child: Text(
                                  cartController.totalItems.toString(),
                                  style: GoogleFonts.rubik(
                                      color: Colors.white, fontSize: 12),
                                ),
                              )
                            : const SizedBox()),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topContainer(),
                      SizedBox(height: screenHeight * 0.02),
                      _buildPopularProducts(),
                      SizedBox(height: screenHeight * 0.02),
                      _buildProductOnSale(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topContainer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff0EBE7f).withOpacity(0.2),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Quickly with Prescription",
                      style: GoogleFonts.rubik(
                        color: const Color(0xff333333),
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0EBE7f),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.01,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Upload Prescription",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Image.asset(
                'assets/images/medicine_screen/medicines/tablet.png',
                height: screenHeight * 0.12,
                fit: BoxFit.contain,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDoctorCard(
      String name, String quantity, String image, double price,
      {int quantityCount = 1}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Image.asset(image,
              height: screenHeight * 0.15,
              width: screenWidth * 0.4,
              fit: BoxFit.contain),
          SizedBox(height: screenHeight * 0.02),
          Text(
            name,
            style: GoogleFonts.rubik(
              color: const Color(0xff333333),
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            quantity,
            style: GoogleFonts.rubik(
              fontSize: screenWidth * 0.035,
              color: const Color(0xff677294),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$${price.toString()}",
                style: GoogleFonts.rubik(
                  color: const Color(0xff333333),
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              IconButton(
                onPressed: () {
                  cartController.addToCart(CartItem(
                      name: name,
                      price: price,
                      image: image,
                      quantityCount: quantityCount));
                  Get.snackbar(
                    "Added to Cart",
                    "$name added successfully!",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(milliseconds: 800),
                    colorText: const Color(0xff0EBE7F),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: const Color(0x000000ff),
                    margin:
                        const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  );
                },
                icon: Icon(
                  Icons.add_box_sharp,
                  color: const Color(0xff0EBE7F),
                  size: screenWidth * 0.08,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPopularProducts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeadline(
            onlyText: false,
            onPressed: () {},
            text: "Popular Tablets",
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDoctorCard(
                    "Xanax",
                    "1 mg tablet",
                    "assets/images/medicine_screen/medicines/xanax_tablet.png",
                    1.00),
                const SizedBox(width: 10),
                _buildDoctorCard(
                    "Vosevi",
                    "100 mg tablet",
                    "assets/images/medicine_screen/medicines/vosevi_tablet.png",
                    2.20),
                const SizedBox(width: 10),
                _buildDoctorCard(
                    "Paracetamol",
                    "100 tablets",
                    "assets/images/medicine_screen/medicines/paracetamol_tablet.png",
                    6.30),
                const SizedBox(width: 10),
                _buildDoctorCard(
                    "Panadol",
                    "500 mg tablet",
                    "assets/images/medicine_screen/medicines/panadol_tablet.png",
                    4.00),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductOnSale() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeadline(
            onlyText: false,
            onPressed: () {},
            text: "Popular Syrup",
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDoctorCard(
                    "Benylin Syrup",
                    "300 ml",
                    "assets/images/medicine_screen/medicines/benylin_syrup.png",
                    20.00),
                const SizedBox(width: 10),
                _buildDoctorCard(
                    "Calmo Syrup",
                    "200 ml",
                    "assets/images/medicine_screen/medicines/calmo_syrup.png",
                    18.00),
                const SizedBox(width: 10),
                _buildDoctorCard(
                    "Cough Syrup",
                    "220 ml",
                    "assets/images/medicine_screen/medicines/cough_syrup.png",
                    12.50),
                const SizedBox(width: 10),
                _buildDoctorCard(
                    "Immu Syrup",
                    "250 ml",
                    "assets/images/medicine_screen/medicines/immu_syrup.png",
                    8.75),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
