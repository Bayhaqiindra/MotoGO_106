import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/constants/colors.dart'; // Ensure AppColors is accessible

class MyBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MyBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 55.0; // Adjusted height for the floating bar
    const double iconSize = 24.0; // Icon size for clarity
    const double labelFontSize = 12.0; // Font size for labels

    return Container(
      // The horizontal padding and vertical padding for floating effect will be in Scaffold's body
      decoration: BoxDecoration(
        color: Colors.white, // White background for the floating bar
        borderRadius: BorderRadius.circular(30), // Rounded corners for the "pill" shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Soft shadow for floating effect
            blurRadius: 10,
            offset: const Offset(0, 5), // Offset for shadow
          ),
        ],
      ),
      height: barHeight, // Set the fixed height for the container
      child: BottomNavigationBar(
        elevation: 0, // Remove default elevation to allow Container's shadow to show
        backgroundColor: Colors.transparent, // Make background transparent
        currentIndex: selectedIndex,
        onTap: onItemSelected,
        selectedItemColor: const Color(0xFF3A60C0), // Blue for selected item
        unselectedItemColor: Colors.grey, // Grey for unselected item
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Keep items fixed when selected
        selectedLabelStyle: const TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: labelFontSize),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: iconSize), // Ikon rumah
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: iconSize), // Ikon profil
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_outlined, size: iconSize), // Ikon grafik untuk Pengeluaran
            label: 'Pengeluaran',
          ),
        ],
      ),
    );
  }
}