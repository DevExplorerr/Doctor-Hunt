// ignore_for_file: unused_local_variable

import 'package:doctor_app_ui/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  bool _isChecked = false;
  bool _obscureText = true;

  void _validateFields() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Name is Required' : null;
      _emailError = _emailController.text.isEmpty
          ? 'Email is Required'
          : !emailRegex.hasMatch(_emailController.text)
              ? 'Enter a valid Email'
              : null;

      _passwordError = _passwordController.text.isEmpty
          ? 'Password is Required'
          : _passwordController.text.length < 6
              ? 'Password should be 6 characters long'
              : null;

      if (_nameError == null && _emailError == null && _passwordError == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 375;
    final isLargeScreen = mediaQuery.size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/auth_image/auth_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 10 : 15,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: isSmallScreen ? 20 : 40,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: mediaQuery.size.height - (isSmallScreen ? 40 : 80),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isSmallScreen ? 20 : 50),
                  Text(
                    'Join us to start searching',
                    style: GoogleFonts.rubik(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'You can search course, apply course and find scholarship for abroad studies',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff677294),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: isSmallScreen ? 30 : 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: socialButton(
                            'Google',
                            'assets/images/auth_image/google_logo.png',
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 10 : 20),
                        Flexible(
                          child: socialButton(
                            'Facebook',
                            'assets/images/auth_image/facebook_logo.png',
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  customTextField(
                    hintText: 'Name',
                    controller: _nameController,
                    errorText: _nameError,
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 15),
                  customTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    errorText: _emailError,
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 15),
                  customTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    errorText: _passwordError,
                    isPassword: true,
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 25),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I agree with the Terms of Service & Privacy Policy',
                          style: GoogleFonts.rubik(
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff677294),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  SizedBox(
                    width: double.infinity,
                    height: isSmallScreen ? 48 : 54,
                    child: ElevatedButton(
                      onPressed: _validateFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0EBE7F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.rubik(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Have an account? Log in',
                      style: GoogleFonts.rubik(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff0EBE7F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget socialButton(String text, String iconPath, {bool isSmallScreen = false}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(iconPath, height: isSmallScreen ? 16 : 19),
      label: Text(
        text,
        style: GoogleFonts.rubik(
          fontSize: isSmallScreen ? 14 : 16,
          fontWeight: FontWeight.w300,
          color: const Color(0xff677294),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.all(isSmallScreen ? 16 : 26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
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
          horizontal: isSmallScreen ? 12 : 20,
          vertical: isSmallScreen ? 14 : 16,
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
  }
}