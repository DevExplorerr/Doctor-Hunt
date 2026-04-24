import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Skin',
        'searchKey': 'Dermatologist',
        'icon': Icons.face_retouching_natural_rounded,
        'colors': [const Color(0xffFE7F44), const Color(0xffFFCF68)],
      },
      {
        'name': 'General',
        'searchKey': 'General Physician',
        'icon': Icons.medical_services_rounded,
        'colors': [const Color(0xff2753F3), const Color(0xff765AFC)],
      },
      {
        'name': 'Surgery',
        'searchKey': 'Surgeon',
        'icon': Icons.content_cut_rounded,
        'colors': [const Color(0xff0EBE7E), const Color(0xff07D9AD)],
      },
      {
        'name': 'Bone',
        'searchKey': 'Orthopedic',
        'icon': Icons.accessibility_new_rounded,
        'colors': [const Color(0xffFF484C), const Color(0xffFF6C60)],
      },
      {
        'name': 'Mental',
        'searchKey': 'Psychologist',
        'icon': Icons.psychology_rounded,
        'colors': [const Color(0xff765AFC), const Color(0xff2753F3)],
      },
      {
        'name': 'Women',
        'searchKey': 'Gynecologist',
        'icon': Icons.pregnant_woman_rounded,
        'colors': [const Color(0xffFF6C60), const Color(0xffFF484C)],
      },
      {
        'name': 'Brain',
        'searchKey': 'Neurologist',
        'icon': Icons.settings_suggest_rounded,
        'colors': [const Color(0xffFE7F44), const Color(0xffFFCF68)],
      },
      {
        'name': 'Dental',
        'searchKey': 'Dentist',
        'icon': Icons.health_and_safety,
        'colors': [const Color(0xff2753F3), const Color(0xff765AFC)],
      },
      {
        'name': 'Kids',
        'searchKey': 'Pediatrician',
        'icon': Icons.child_care_rounded,
        'colors': [const Color(0xff0EBE7E), const Color(0xff07D9AD)],
      },
      {
        'name': 'Heart',
        'searchKey': 'Cardiologist',
        'icon': CupertinoIcons.heart_fill,
        'colors': [const Color(0xffFF484C), const Color(0xffFF6C60)],
      },
      {
        'name': 'Medicine',
        'searchKey': 'Medicine',
        'icon': Icons.medication_rounded,
        'colors': [const Color(0xffFE7F44), const Color(0xffFFCF68)],
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: .horizontal,
        padding: const .symmetric(horizontal: 15),
        clipBehavior: .none,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                '/all-doctors',
                arguments: {
                  'category': item['searchKey'],
                  'title': item['name'],
                },
              );
            },
            child: Padding(
              padding: const .only(right: 15),
              child: Column(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: item['colors'],
                        begin: .topLeft,
                        end: .bottomRight,
                      ),
                      borderRadius: .circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: (item['colors'][0] as Color).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(item['icon'], color: AppColors.white, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['name'],
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontWeight: .w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
