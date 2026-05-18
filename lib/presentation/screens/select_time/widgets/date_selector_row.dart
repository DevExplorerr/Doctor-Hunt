import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateSelectorRow extends StatelessWidget {
  const DateSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 80,
      width: .infinity,
      child: ListView.separated(
        itemCount: controller.upcomingDays.length,
        scrollDirection: .horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const .symmetric(horizontal: 20, vertical: 10),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final day = controller.upcomingDays[index];

          final String dayLabel = index == 0
              ? "Today, ${DateFormat('d MMM').format(day)}"
              : index == 1
              ? "Tomorrow, ${DateFormat('d MMM').format(day)}"
              : DateFormat('EEE, d MMM').format(day);

          return Obx(() {
            final bool isSelected =
                DateFormat(
                  'yyyy-MM-dd',
                ).format(controller.selectedDate.value) ==
                DateFormat('yyyy-MM-dd').format(day);

            final int availableSlots = controller.getAvailableSlotsCountForDate(
              day,
            );
            final String slotStatus = availableSlots > 0
                ? "$availableSlots slots available"
                : "No slots available";

            return GestureDetector(
              onTap: () {
                controller.selectedDate.value = day;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 160,
                alignment: .center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: .circular(8),
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      dayLabel,
                      style: textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slotStatus,
                      style: textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
