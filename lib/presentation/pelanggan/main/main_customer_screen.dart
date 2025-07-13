import 'package:flutter/material.dart';
import 'package:tugas_akhir/presentation/pelanggan/booking/widget/booking_form_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/history/pages/customer_history_combined_page.dart';
import 'package:tugas_akhir/presentation/pelanggan/home/home_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/profile/pelanggan_profile_screen.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/widget/riwayat_transaction_page.dart';

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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF3A60C0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: 'Transaction'),
          
        ],
      ),
    );
  }
}
