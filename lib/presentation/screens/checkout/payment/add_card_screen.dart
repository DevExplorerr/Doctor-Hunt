// ignore_for_file: deprecated_member_use

import 'package:doctor_hunt/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => AddCardScreenState();
}

class AddCardScreenState extends State<AddCardScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg/payment_screen_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section
                  TopSection(
                    text: "Card Details",
                    backButton:
                        Icon(Icons.arrow_back_ios, size: screenWidth * 0.045),
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Credit Card Preview
                  CreditCardWidget(
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    showBackView: isCvvFocused,
                    cardBgColor: Colors.black,
                    glassmorphismConfig: Glassmorphism(
                      blurX: 12,
                      blurY: 12,
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange: (value) {},
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Credit Card Form
                  CreditCardForm(
                    formKey: formKey,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    onCreditCardModelChange: (CreditCardModel data) {
                      setState(() {
                        cardNumber = data.cardNumber;
                        expiryDate = data.expiryDate;
                        cardHolderName = data.cardHolderName;
                        cvvCode = data.cvvCode;
                        isCvvFocused = data.isCvvFocused;
                      });
                    },
                    themeColor: Colors.white,
                    obscureCvv: true,
                    obscureNumber: true,
                    cursorColor: const Color(0xff0EBE7f),
                    cardNumberDecoration:
                        _inputDecoration("Card Number", screenWidth),
                    expiryDateDecoration:
                        _inputDecoration("Expiry Date", screenWidth),
                    cvvCodeDecoration: _inputDecoration("CVV", screenWidth),
                    cardHolderDecoration:
                        _inputDecoration("Card Holder Name", screenWidth),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Validate Button
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                        ),
                        backgroundColor: const Color(0xff0ebe7f),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context, {
                            'cardNumber': cardNumber,
                            'expiryDate': expiryDate,
                            'cardHolderName': cardHolderName,
                          });
                          Get.snackbar(
                            "Success",
                            "Card saved successfully",
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(milliseconds: 800),
                            colorText: const Color(0xff000000),
                            padding: const EdgeInsets.all(15),
                            backgroundColor: const Color(0x000000ff),
                            margin: const EdgeInsets.only(
                                bottom: 20, left: 10, right: 10),
                          );
                        }
                      },
                      child: Text(
                        "Validate",
                        style: GoogleFonts.rubik(
                          fontSize: screenWidth * 0.045,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, double screenWidth) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.rubik(
        fontSize: screenWidth * 0.038,
        fontWeight: FontWeight.w300,
        color: const Color(0xff677294),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.035,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      filled: true,
      fillColor: const Color(0xffFFFFFF),
    );
  }
}
