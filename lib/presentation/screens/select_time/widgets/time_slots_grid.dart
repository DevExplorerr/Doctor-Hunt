import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeSlotsGrid extends StatelessWidget {
  final String sectionTitle;
  final List<String> slots;

  const TimeSlotsGrid({
    super.key,
    required this.sectionTitle,
    required this.slots,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final textTheme = Theme.of(context).textTheme;

    if (slots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .symmetric(horizontal: 20),
          child: Text(
            sectionTitle,
            style: textTheme.titleMedium?.copyWith(fontWeight: .w700),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          padding: const .symmetric(horizontal: 20, vertical: 4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (context, index) {
            final timeSlot = slots[index];

            return Obx(() {
              final isSelected = controller.selectedTime.value == timeSlot;

              return GestureDetector(
                onTap: () => controller.selectedTime.value = timeSlot,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(8),
                  ),
                  child: Text(
                    timeSlot,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isSelected ? AppColors.white : AppColors.primary,
                      fontWeight: .w700,
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }
}
