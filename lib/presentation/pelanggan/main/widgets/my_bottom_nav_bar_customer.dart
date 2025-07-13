import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/constants/colors.dart'; // Pastikan AppColors dapat diakses

class MyBottomNavBarCustomer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MyBottomNavBarCustomer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 60.0; // Tinggi yang sedikit lebih besar untuk estetika
    const double iconSize = 26.0; // Ukuran ikon yang lebih besar
    const double labelFontSize = 12.0; // Ukuran font label

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // Latar belakang putih
        borderRadius: BorderRadius.circular(30), // Sudut membulat untuk bentuk "pill"
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Bayangan lembut untuk efek mengambang
            blurRadius: 15, // Blur lebih besar
            offset: const Offset(0, 8), // Offset bayangan
          ),
        ],
      ),
      height: barHeight, // Tetapkan tinggi container
      child: BottomNavigationBar(
        elevation: 0, // Hapus elevasi default agar bayangan Container terlihat
        backgroundColor: Colors.transparent, // Jadikan latar belakang transparan
        currentIndex: selectedIndex,
        onTap: onItemSelected,
        selectedItemColor: AppColors.primary, // Warna utama (biru gelap) untuk item terpilih
        unselectedItemColor: AppColors.grey, // Abu-abu untuk item tidak terpilih
        showSelectedLabels: true, // Tampilkan label untuk yang terpilih
        showUnselectedLabels: true, // Tampilkan label untuk yang tidak terpilih
        type: BottomNavigationBarType.fixed, // Pastikan item tetap di tempatnya
        selectedLabelStyle: const TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: labelFontSize),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: iconSize), // Ikon Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined, size: iconSize), // Ikon Booking
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined, size: iconSize), // Ikon History
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: iconSize), // Ikon Profile
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined, size: iconSize), // Ikon Transaction (mengganti chat_rounded)
            label: 'Transaction',
          ),
        ],
      ),
    );
  }
}
