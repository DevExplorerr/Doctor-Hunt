import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/controllers/appointment_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/widgets/buttons/custom_button.dart';
import 'package:doctor_hunt/presentation/widgets/feedback/custom_dialog.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      child: MainWrapper(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Text("My Appointments", style: textTheme.headlineSmall),
          leading: Padding(
            padding: const .only(left: 18),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: const CircleBorder(),
              ),
            ),
          ),

          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.secondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: .w700),
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Completed"),
              Tab(text: "Canceled"),
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.upcomingAppointments.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return TabBarView(
            children: [
              _buildList(
                controller.upcomingAppointments,
                "upcoming",
                controller,
                textTheme,
              ),
              _buildList(
                controller.completedAppointments,
                "completed",
                controller,
                textTheme,
              ),
              _buildList(
                controller.canceledAppointments,
                "canceled",
                controller,
                textTheme,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>> appointments,
    String type,
    AppointmentController controller,
    TextTheme textTheme,
  ) {
    if (appointments.isEmpty) {
      return Center(
        child: AppEmptyState(
          title: "No $type appointments",
          description: "You have no $type appointments at this time",
          icon: Icons.calendar_month,
        ),
      );
    }

    return ListView.builder(
      padding: const .all(20),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appt = appointments[index];
        DateTime parsedDate = DateTime.parse(appt['date']);
        String displayDate = DateFormat('dd MMM, yyyy').format(parsedDate);
        String displayTime = appt['time'] ?? 'TBD';
        String specialty = appt['specialty'] ?? 'Medical Consultation';
        String image = appt['image'];
        double pricePerHour = appt['pricePerHour'] ?? 0.0;
        int experience = appt['experience'] ?? 1;

        return Container(
          margin: const .only(bottom: 15),
          padding: const .all(15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: .circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  ClipRRect(
                    borderRadius: .circular(8),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      height: 90,
                      width: 90,
                      fit: .cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          appt['doctorName'] ?? 'Your Doctor',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: .w600,
                          ),
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          specialty,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              "${experience.toString()} Years Experience",
                              style: textTheme.bodySmall,
                            ),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "\$ ",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: .w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${pricePerHour.toString()}/hr",
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const .symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: .circular(12),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          displayDate,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          displayTime,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (type == "upcoming") ...[
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          CustomDialog.show(
                            context,
                            child: Column(
                              mainAxisSize: .min,
                              children: [
                                Text(
                                  "Cancel Appointment",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: AppColors.primary),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Are you sure you want to cancel this booking?",
                                  textAlign: .center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          "No",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomButton(
                                        height: 45,
                                        text: "Yes, Cancel",
                                        isLoading: controller.isLoading.value,
                                        onTap: () {
                                          Get.back();
                                          controller.cancelAppointment(
                                            appt['id'],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: const BorderSide(color: AppColors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8),
                          ),
                        ),

                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Reschedule",
                        onTap: () {
                          controller.initiateReschedule(
                            appt['doctorId'],
                            appt['id'],
                          );
                        },
                        height: 45,
                        width: .infinity,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
