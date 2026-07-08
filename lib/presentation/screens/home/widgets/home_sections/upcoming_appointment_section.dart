import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/controllers/home_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/home/appointments/my_appointments_screen.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_headline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UpcomingAppointmentSection extends StatefulWidget {
  const UpcomingAppointmentSection({super.key});

  @override
  State<UpcomingAppointmentSection> createState() =>
      _UpcomingAppointmentSectionState();
}

class _UpcomingAppointmentSectionState
    extends State<UpcomingAppointmentSection> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<HomeController>();

    return Obx(() {
      final appointments = controller.upcomingAppointments;

      if (appointments.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .symmetric(horizontal: 15.0),
            child: CustomHeadline(
              text: "Upcoming Appointments",
              onlyText: false,
              onPressed: () {
                Get.to(() => const MyAppointmentsScreen());
              },
            ),
          ),
          const SizedBox(height: 15),

          SizedBox(
            height: 180,
            child: PageView.builder(
              clipBehavior: .none,
              controller: _pageController,
              itemCount: appointments.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final appt = appointments[index];

                DateTime parsedDate = DateTime.parse(appt['date']);
                String displayDate = DateFormat(
                  'dd EEE, yyyy',
                ).format(parsedDate);
                String displayTime = appt['time'] ?? 'TBD';
                String doctorName = appt['doctorName'] ?? 'Your Doctor';
                String image = appt['image'];
                String specialty = appt['specialty'] ?? 'Medical Consultation';

                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                    } else {
                      value = (index == 0) ? 0.0 : 1.0;
                    }

                    double scale = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                    double dropY = (value.abs() * 20.0);

                    return Transform.translate(
                      offset: Offset(0, dropY),
                      child: Transform.scale(
                        scale: Curves.easeOut.transform(scale),
                        child: child,
                      ),
                    );
                  },
                  child: _buildAppointmentCard(
                    doctorName,
                    image,
                    specialty,
                    displayDate,
                    displayTime,
                    textTheme,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      );
    });
  }

  Widget _buildAppointmentCard(
    String doctorName,
    String image,
    String specialty,
    String displayDate,
    String displayTime,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const .symmetric(vertical: 5),
      padding: const .all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: .circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: .circle,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    fit: .cover,
                    imageUrl: image,
                    placeholder: (_, __) =>
                        LoadingAnimationWidget.threeArchedCircle(
                          color: AppColors.primary,
                          size: 20,
                        ),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.person, color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      doctorName,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: .w700,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const .symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
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
        ],
      ),
    );
  }
}
