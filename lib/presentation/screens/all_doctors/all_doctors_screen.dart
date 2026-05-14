import 'package:doctor_hunt/controllers/all_doctors_controller.dart';
import 'package:doctor_hunt/controllers/booking_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/all_doctors/widgets/all_doctors_shimmer.dart';
import 'package:doctor_hunt/presentation/screens/all_doctors/widgets/doctor_list_item.dart';
import 'package:doctor_hunt/presentation/screens/all_doctors/widgets/filter_chips_row.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/search/custom_search_bar.dart';
import 'package:doctor_hunt/presentation/widgets/state/app_empty_state.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllDoctorsController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainWrapper(
        child: Column(
          children: [
            Obx(
              () => CustomAppBar(
                title: "${controller.title.value} Doctors",
                showReset:
                    controller.currentType != null ||
                    controller.selectedFilter.value != "All",
                onReset: () => controller.resetFilters(),
              ),
            ),
            Padding(
              padding: const .symmetric(horizontal: 15.0),
              child: CustomSearchBar(
                hintText: "Search...",
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                onChanged: (value) => controller.searchDoctors(value),
              ),
            ),

            const SizedBox(height: 20),
            FilterChipsRow(controller: controller),
            const SizedBox(height: 10),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value ||
                    controller.isSearching.value) {
                  return const AllDoctorsShimmer();
                }

                if (controller.filteredDoctors.isEmpty) {
                  return const AppEmptyState(
                    title: 'No doctors found.',
                    description:
                        'Try searching for a different name or specialty.',
                    icon: Icons.search_off_rounded,
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const .symmetric(horizontal: 15, vertical: 20),
                  itemCount: controller.hasMore.value
                      ? controller.filteredDoctors.length + 1
                      : controller.filteredDoctors.length,
                  itemBuilder: (context, index) {
                    if (index < controller.filteredDoctors.length) {
                      final doctor = controller.filteredDoctors[index];
                      return GestureDetector(
                        onTap: () {
                          final bookingController = Get.put(
                            BookingController(),
                          );
                          bookingController.selectedDoctor.value = doctor;
                          Get.toNamed('/doctor-details');
                        },
                        child: DoctorListItem(doctor: doctor),
                      );
                    } else {
                      return Padding(
                        padding: const .symmetric(vertical: 20),
                        child: Center(
                          child: LoadingAnimationWidget.threeRotatingDots(
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
