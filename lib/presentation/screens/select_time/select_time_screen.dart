import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/card/doctor_details_card.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/app_snack_bar.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:doctor_hunt/presentation/screens/select_time/widgets/date_selector_row.dart';
import 'package:doctor_hunt/presentation/screens/select_time/widgets/time_slots_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SelectTimeScreen extends StatelessWidget {
  const SelectTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final doctor = controller.selectedDoctor.value!;

    return MainWrapper(
      child: Obx(() {
        final bool hasNoSlots =
            controller.afternoonSlots.isEmpty &&
            controller.eveningSlots.isEmpty;

        return SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(title: "Select Time"),
              const SizedBox(height: 10),

              DoctorDetailsCard(
                doctor: doctor,
                buttonText: (hasNoSlots || controller.isLoading.value)
                    ? null
                    : "Next",
                onTap: (hasNoSlots || controller.isLoading.value)
                    ? null
                    : () {
                        if (controller.selectedTime.value.isEmpty) {
                          AppSnackBar.show(
                            title: "Required",
                            message:
                                "Please choose a preferred time slot first",
                          );
                        } else {
                          Get.toNamed('/appointment-details');
                        }
                      },
              ),
              const SizedBox(height: 20),
              const DateSelectorRow(),
              const SizedBox(height: 25),

              (() {
                if (controller.isLoading.value) {
                  return Padding(
                    padding: const .symmetric(vertical: 60),
                    child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  );
                }

                if (hasNoSlots) {
                  return Column(
                    children: [
                      const AppEmptyState(
                        title: "No Slots Available",
                        description:
                            "This doctor has no active availability today.\nCheck upcoming dates or query the branch",
                        icon: Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const .symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            CustomButton(
                              text: "Contact Clinic",
                              onTap: () {},
                              height: 50,
                              borderRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    TimeSlotsGrid(
                      sectionTitle: "Afternoon slots",
                      slots: controller.afternoonSlots,
                    ),
                    const SizedBox(height: 25),
                    TimeSlotsGrid(
                      sectionTitle: "Evening slots",
                      slots: controller.eveningSlots,
                    ),
                  ],
                );
              })(),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
