// ignore_for_file: unused_local_variable

import 'package:doctor_app_ui/presentation/screens/auth/signup_screen.dart';
import 'package:doctor_app_ui/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  bool _obscureText = true;

  void _validateFields() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    setState(() {
      _emailError = _emailController.text.isEmpty
          ? 'Email is Required'
          : !emailRegex.hasMatch(_emailController.text)
              ? 'Enter a valid Email'
              : null;

      _passwordError = _passwordController.text.isEmpty
          ? 'Password  is Required'
          : _passwordController.text.length < 6
              ? 'Password must be atleast 6 characters long'
              : null;
    });
    if (_emailError == null && _passwordError == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
  final isSmallScreen = mediaQuery.size.width < 375;
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/auth_image/auth_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02, horizontal: size.width * 0.04),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, vertical: size.height * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.07),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.rubik(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000)),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'You can search course, apply course and find scholarship for abroad studies',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff677294)),
                ),
                SizedBox(height: size.height * 0.06),
                Padding(
                  padding: EdgeInsets.only(top: isSmallScreen ? 30 : 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: isSmallScreen ? 5 : 10),
          child: socialButton(
            'Google',
            'assets/images/auth_image/google_logo.png',
            isSmallScreen: isSmallScreen,
          ),
        ),
      ),
      SizedBox(width: isSmallScreen ? 10 : 20),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: isSmallScreen ? 5 : 10),
          child: socialButton(
            'Facebook',
            'assets/images/auth_image/facebook_logo.png',
            isSmallScreen: isSmallScreen,
          ),
        ),
      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                customTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    errorText: _emailError),
                SizedBox(height: size.height * 0.02),
                customTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  errorText: _passwordError,
                  isPassword: true,
                ),
                SizedBox(height: size.height * 0.05),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                      onPressed: _validateFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0EBE7F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.rubik(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffFFFFFF)),
                      )),
                ),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                  onTap: () {
                    showForgotPasswordSheet(context);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.rubik(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff0EBE7F)),
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: Text(
                    'Don’t have an account? Join us',
                    style: GoogleFonts.rubik(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff0EBE7F)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialButton(String text, String iconPath, {bool isSmallScreen = false}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(iconPath, height: isSmallScreen ? 16 : 20),
      label: Text(
        text,
        style: GoogleFonts.rubik(
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xff677294)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), side: BorderSide.none),
      ),
    );
  }

  Widget customTextField({
  required String hintText,
  required TextEditingController controller,
  String? errorText,
  bool isPassword = false,
  bool isSmallScreen = false,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscureText : false,
        cursorColor: const Color(0xff0EBE7f),
        decoration: InputDecoration(
          errorText: errorText,
          hintText: hintText,
          hintStyle: GoogleFonts.rubik(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w300,
            color: const Color(0xff677294),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 16 : 18,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xff677294),
                    size: isSmallScreen ? 20 : 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: const Color(0xffFFFFFF),
        ),
      );
    },
  );
}

  void showForgotPasswordSheet(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        String? emailError;
        return StatefulBuilder(builder: (context, setModalState) {
          void validateFields() {
            setModalState(() {
              emailError = emailController.text.isEmpty
                  ? 'Email is Required'
                  : !emailController.text.contains('@gmail.com')
                      ? 'Enter a valid Email'
                      : null;
            });

            if (emailError == null) {
              Navigator.pop(context);
              showOTPVerificationSheet(context);
            }
          }

          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                left: MediaQuery.of(context).size.width * 0.06,
                right: MediaQuery.of(context).size.width * 0.06,
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffC4C4C4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  'Forgot Password',
                  style: GoogleFonts.rubik(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  'Enter your email for verification. We will send a 4-digit code to your email.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff677294)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                TextFormField(
                  controller: emailController,
                  cursorColor: const Color(0xff0EBE7F),
                  decoration: InputDecoration(
                    errorText: emailError,
                    hintText: 'Email',
                    hintStyle: GoogleFonts.rubik(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff677294)),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xffFFFFFF),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      validateFields();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0EBE7F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.rubik(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffFFFFFF)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void showOTPVerificationSheet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final otpControllers =
        List.generate(4, (index) => TextEditingController());
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.08,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: screenWidth * 0.3,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xffC4C4C4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Enter 4 Digits Code',
                      style: GoogleFonts.rubik(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Enter the 4-digit code sent to your email.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff677294),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: screenWidth * 0.14,
                          height: screenWidth * 0.14,
                          child: TextFormField(
                            cursorColor: const Color(0xff0EBE7F),
                            controller: otpControllers[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSans(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff0EBE7F),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            validator: (value) =>
                                value == null || value.isEmpty ? '!' : null,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorStyle: const TextStyle(fontSize: 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: screenWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            showResetPasswordSheet(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0EBE7F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.rubik(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showResetPasswordSheet(BuildContext context) {
    final TextEditingController newPasswordController =
        TextEditingController();
    final TextEditingController reEnterPasswordController =
        TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (context) {
          String? newPasswordError;
          String? reEnterPasswordError;
          return StatefulBuilder(
            builder: (context, setModalState) {
              void validateFields() {
                setModalState(() {
                  newPasswordError = newPasswordController.text.isEmpty
                      ? 'Password is Required '
                      : newPasswordController.text.length < 6
                          ? 'Password must be at least 6 characters long'
                          : null;

                  reEnterPasswordError =
                      reEnterPasswordController.text.isEmpty
                          ? 'Please Confirm your Password'
                          : reEnterPasswordController.text !=
                                  newPasswordController.text
                              ? 'Passwords do not match'
                              : null;
                });

                if (newPasswordError == null &&
                    reEnterPasswordError == null) {
                  Navigator.pop(context);
                }
              }

              return Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.07,
                  left: screenWidth * 0.06,
                  right: screenWidth * 0.06,
                  bottom: screenHeight * 0.07,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.005,
                      decoration: BoxDecoration(
                        color: const Color(0xffC4C4C4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Reset Password',
                      style: GoogleFonts.rubik(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff000000)),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      'Set a new password for your account.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff677294)),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    TextFormField(
                      controller: newPasswordController,
                      cursorColor: const Color(0xff0EBE7F),
                      obscureText: true,
                      decoration: InputDecoration(
                        errorText: newPasswordError,
                        hintText: 'New Password',
                        hintStyle: GoogleFonts.rubik(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff677294)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(
                          Icons.visibility_off,
                          color: Color(0xff677294),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      controller: reEnterPasswordController,
                      cursorColor: const Color(0xff0EBE7F),
                      obscureText: true,
                      decoration: InputDecoration(
                        errorText: reEnterPasswordError,
                        hintText: 'Re-enter Password',
                        hintStyle: GoogleFonts.rubik(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff677294)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(
                          Icons.visibility_off,
                          color: Color(0xff677294),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: screenWidth,
                      child: ElevatedButton(
                        onPressed: validateFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0EBE7F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Update Password',
                            style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
