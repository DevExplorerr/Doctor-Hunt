import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped, 
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xff0EBE7E),
        unselectedItemColor: const Color(0xff858EA9),
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
    );
  }

  Widget _buildIcon(IconData icon, int index, int selectedIndex) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selectedIndex == index ? const Color(0xff0EBE7E) : Colors.transparent,
      ),
      child: Icon(
        icon,
        color: selectedIndex == index ? Colors.white : const Color(0xff858EA9),
      ),
    );
  }
}
