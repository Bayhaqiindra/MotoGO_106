import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/constants/colors.dart';
import 'package:tugas_akhir/presentation/admin/booking/pages/admin_booking_list_page.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_service/pages/admin_all_payment_service_page.dart';
import 'package:tugas_akhir/presentation/admin/konfirmasi_payment_sparepart/pages/admin_all_payments_page.dart';
import 'package:tugas_akhir/presentation/admin/service/widget/admin_service_screen.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/pages/sparepart_list_page.dart';
import 'package:tugas_akhir/presentation/admin/transaction/widget/admin_all_transactions_page.dart';
import 'package:tugas_akhir/presentation/admin/home/components/admin_menu_card_grid.dart';
import 'package:tugas_akhir/presentation/admin/home/components/admin_welcome_header.dart';
import 'package:tugas_akhir/presentation/admin/profile/bloc/profile_admin_bloc.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> adminMenus = [
      {
        'title': 'Kelola Service',
        'icon': Icons.build_circle_outlined,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminServiceScreen()),
          );
        },
      },
      {
        'title': 'Kelola Sparepart',
        'icon': Icons.tune_outlined,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SparepartListPage()),
          );
        },
      },
      {
        'title': 'Kelola Booking',
        'icon': Icons.calendar_month_outlined,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminBookingListPage()),
          );
        },
      },
      {
        'title': 'Transaksi',
        'icon': Icons.receipt_long_outlined,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminAllTransactionsPage()),
          );
        },
      },
      {
        'title': 'Sparepart',
        'icon': Icons.payments_outlined,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminAllPaymentsPage()),
          );
        },
      },
      {
        'title': 'Service',
        'icon': Icons.fact_check_outlined,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminAllPaymentPage()),
          );
        },
      },
    ];

    const double headerHeight = 200.0; // Tinggi header tetap

    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<AdminProfileBloc, AdminProfileState>(
        builder: (context, state) {
          String adminName = 'Admin';
          String? profilePictureUrl;

          if (state is AdminProfileSuccess && state.responseModel.data != null) {
            adminName = state.responseModel.data!.name ?? 'Admin';
            profilePictureUrl = state.responseModel.data!.profilePicture;
          } else if (state is AdminProfileLoading) {
            adminName = 'Memuat...';
          }

          return Stack(
            children: [
              // Header Biru (AdminWelcomeHeader)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerHeight + MediaQuery.of(context).padding.top,
                child: AdminWelcomeHeader(
                  adminName: adminName,
                  profilePictureUrl: profilePictureUrl,
                  onNotificationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifikasi ditekan!')),
                    );
                  },
                ),
              ),

              // Area Putih dengan Menu Grid
              Positioned(
                top: headerHeight - 1, // <--- DIUBAH: Meningkatkan overlap (naik lebih tinggi)
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    // Padding disesuaikan untuk memastikan konten tidak terpotong
                    padding: const EdgeInsets.only(top: 50.0), // <--- DIUBAH: Menambah padding atas
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdminMenuCardGrid(menus: adminMenus),
                        Spaces.verticalLarge,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}