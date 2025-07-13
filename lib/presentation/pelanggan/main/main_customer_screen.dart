import 'package:flutter/material.dart';
import 'package:tugas_akhir/presentation/pelanggan/booking/widget/booking_form_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/history/pages/customer_history_combined_page.dart';
import 'package:tugas_akhir/presentation/pelanggan/home/home_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/pelanggan_profile_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/widget/riwayat_transaction_page.dart';
import 'package:tugas_akhir/presentation/pelanggan/main/widgets/my_bottom_nav_bar_customer.dart'; // <--- IMPORT BARU

class MainCustomerScreen extends StatefulWidget {
  const MainCustomerScreen({super.key});

  @override
  State<MainCustomerScreen> createState() => _MainCustomerScreenState();
}

class _MainCustomerScreenState extends State<MainCustomerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingFormScreen(),
    const CustomerHistoryPage(),
    const PelangganProfileScreen(),
    const RiwayatTransactionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Penting: Memungkinkan body meluas di belakang bar mengambang
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding( // Menambahkan Padding untuk membuat bar "mengambang"
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), // Sesuaikan nilai ini untuk jarak yang diinginkan
        child: MyBottomNavBarCustomer( // <--- Menggunakan widget kustom
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
