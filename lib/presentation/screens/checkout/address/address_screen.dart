import 'package:doctor_hunt/presentation/widgets/header/top_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  final Map<String, String>? initialAddress;

  const AddressScreen({super.key, this.initialAddress});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int _currentStep = 0;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      firstNameController.text = widget.initialAddress!['firstName'] ?? '';
      lastNameController.text = widget.initialAddress!['lastName'] ?? '';
      addressController.text = widget.initialAddress!['address'] ?? '';
      postcodeController.text = widget.initialAddress!['postcode'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg/delivery_address_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: isLargeScreen ? 50 : 16,
          ),
          child: Column(
            children: [
              TopSection(
                text: "Add / Edit Address",
                backButton: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme:
                          const ColorScheme.light(primary: Color(0xff0EBE7F))),
                  child: Form(
                    key: _formKey,
                    child: Stepper(
                      type: StepperType.vertical,
                      currentStep: _currentStep,
                      onStepTapped: (step) =>
                          setState(() => _currentStep = step),
                      onStepContinue: _handleNextStep,
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        }
                      },
                      controlsBuilder: (context, details) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_currentStep > 0)
                                Container(
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff000000),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: details.onStepCancel,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff000000),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: Text(
                                      "BACK",
                                      style: GoogleFonts.rubik(
                                          color: const Color(0xffFFFFFF)),
                                    ),
                                  ),
                                ),
                              Container(
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: Color(0xff0EBE7f),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff0EBE7F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    _currentStep == 2 ? "CONFIRM" : "NEXT",
                                    style: GoogleFonts.rubik(
                                        color: const Color(0xffFFFFFF)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      steps: [
                        Step(
                          title: Text(
                            "Personal Information",
                            style: GoogleFonts.rubik(
                              color: const Color(0xff333333),
                            ),
                          ),
                          content: Column(
                            children: [
                              _buildTextField(
                                controller: firstNameController,
                                hint: "First Name",
                                validator: (value) => value!.isEmpty
                                    ? 'First name is required'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: lastNameController,
                                hint: "Last Name",
                                validator: (value) => value!.isEmpty
                                    ? 'Last name is required'
                                    : null,
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep > 0
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: Text("Address Details",
                              style: GoogleFonts.rubik(
                                color: const Color(0xff333333),
                              )),
                          content: Column(
                            children: [
                              _buildTextField(
                                controller: addressController,
                                hint: "Full Address",
                                validator: (value) => value!.isEmpty
                                    ? 'Address is required'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: postcodeController,
                                hint: "Postcode",
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty
                                    ? 'Postcode is required'
                                    : null,
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 1,
                          state: _currentStep > 1
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: Text("Confirmation",
                              style: GoogleFonts.rubik(
                                color: const Color(0xff333333),
                              )),
                          content: _buildSummaryBox(),
                          isActive: _currentStep >= 2,
                          state: StepState.complete,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      cursorColor: const Color(0xff0EBE7F),
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: const Color(0xff677294)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildSummaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
              "Name", "${firstNameController.text} ${lastNameController.text}"),
          const SizedBox(height: 8),
          _buildSummaryRow("Address", addressController.text),
          const SizedBox(height: 8),
          _buildSummaryRow("Postcode", postcodeController.text),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.bold,
              color: const Color(0xff0EBE7F),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.rubik(color: const Color(0xff333333)),
          ),
        ),
      ],
    );
  }

  void _handleNextStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) return;
      if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
        _showError("Please fill all personal information");
        return;
      }
    } else if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
      if (addressController.text.isEmpty || postcodeController.text.isEmpty) {
        _showError("Please fill all address details");
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _showSuccess();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess() {
    final Map<String, String> userDetails = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "address": addressController.text,
      "postcode": postcodeController.text,
    };
    Navigator.pop(context, userDetails);
  }
}
