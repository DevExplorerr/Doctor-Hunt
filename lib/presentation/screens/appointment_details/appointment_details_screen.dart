import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/appointment_details/widgets/patient_type_selector.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/card/doctor_details_card.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final doctor = controller.selectedDoctor.value!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainWrapper(
        child: Column(
          children: [
            const CustomAppBar(title: "Appointment"),
            const SizedBox(height: 10),
            Obx(() {
              final bool isProcessing = controller.isLoading.value;
              return DoctorDetailsCard(
                doctor: doctor,
                isLoading: isProcessing,
                buttonText: "Confirm & Book",
                onTap: isProcessing
                    ? null
                    : () => _processAppointmentBooking(
                        context,
                        controller,
                        doctor,
                      ),
              );
            }),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const .symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Appointment For",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: controller.patientNameController,
                      hintText: "Patient Name",
                      keyboardType: .name,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: controller.contactNumberController,
                      textInputAction: .done,
                      keyboardType: .phone,
                      hintText: "Contact Number",
                    ),
                    const SizedBox(height: 30),
                    const PatientTypeSelector(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processAppointmentBooking(
    BuildContext context,
    BookingController controller,
    dynamic doctor,
  ) async {
    if (controller.patientNameController.text.trim().isEmpty ||
        controller.contactNumberController.text.trim().isEmpty ||
        controller.selectedPatientType.isEmpty) {
      AppSnackBar.show(
        title: "Required",
        message: "Please fill out all patient details",
        isError: true,
      );
      return;
    }
    bool success = await controller.confirmBooking();

    if (success && context.mounted) {
      String formattedDate = DateFormat(
        'd MMM yyyy',
      ).format(controller.selectedDate.value);
      String selectedTime = controller.selectedTime.value;

      CustomDialog.show(
        context,
        barrierDismissible: false,
        child: _buildThankYouLayout(
          context,
          doctor.name,
          doctor.specialty,
          formattedDate,
          selectedTime,
        ),
      );
    }
  }

  Widget _buildThankYouLayout(
    BuildContext context,
    String name,
    String specialty,
    String date,
    String time,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: .min,
      children: [
        Container(
          padding: const .all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: .circle,
          ),
          child: const Icon(
            Icons.thumb_up_alt_rounded,
            size: 55,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 25),

        Text("Thank You!", style: textTheme.headlineMedium),
        const SizedBox(height: 5),
        Text(
          "Appointment Successful",
          style: textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 25),

        Text(
          "You booked an appointment with $name ($specialty) on $date at $time",
          textAlign: .center,
          style: textTheme.bodyMedium?.copyWith(height: 1.5, fontWeight: .w500),
        ),
        const SizedBox(height: 30),

        CustomButton(
          text: "Done",
          onTap: () {
            Get.offAllNamed('/home');
          },
          height: 50,
          borderRadius: 12,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: Text(
            "Edit your appointment",
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: .w500,
            ),
          ),
        ),
      ],
    );
  }
}
