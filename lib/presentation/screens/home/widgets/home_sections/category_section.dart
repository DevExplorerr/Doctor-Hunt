import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Dental',
        'icon': Icons.health_and_safety,
        'colors': [const Color(0xff2753F3), const Color(0xff765AFC)],
      },
      {
        'name': 'Heart',
        'icon': CupertinoIcons.heart_fill,
        'colors': [const Color(0xff0EBE7E), const Color(0xff07D9AD)],
      },
      {
        'name': 'Eye',
        'icon': Icons.visibility_rounded,
        'colors': [const Color(0xffFE7F44), const Color(0xffFFCF68)],
      },
      {
        'name': 'Brain',
        'icon': Icons.psychology,
        'colors': [const Color(0xffFF484C), const Color(0xffFF6C60)],
      },
      {
        'name': 'Ear',
        'icon': CupertinoIcons.ear,
        'colors': [const Color(0xff2753F3), const Color(0xff765AFC)],
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
          return Padding(
            padding: const .only(right: 15),
            child: Column(
              children: [
                // Icon Box
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item['colors'],
                      begin: .topLeft,
                      end: .bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
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
                  child: Icon(item['icon'], color: Colors.white, size: 30),
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
          );
        },
      ),
    );
  }
}
