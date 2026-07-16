import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const .only(
          topLeft: .circular(20),
          topRight: .circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const .only(
          topLeft: .circular(20),
          topRight: .circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          type: .fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.secondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home_rounded, 0, selectedIndex),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.favorite, 1, selectedIndex),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.local_pharmacy, 2, selectedIndex),
              label: "Messages",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person, 3, selectedIndex),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, int selectedIndex) {
    return Container(
      padding: const .all(10),
      decoration: BoxDecoration(
        shape: .circle,
        color: selectedIndex == index ? AppColors.primary : Colors.transparent,
      ),
      child: Icon(
        icon,
        color: selectedIndex == index ? AppColors.white : AppColors.secondary,
      ),
    );
  }
}
