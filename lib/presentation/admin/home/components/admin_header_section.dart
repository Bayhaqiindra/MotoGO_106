// lib/screens/admin/home/components/admin_welcome_header.dart
import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/constants/colors.dart'; // Import AppColors

class AdminWelcomeHeader extends StatelessWidget {
  final String adminName;
  final String? profilePictureUrl;
  final VoidCallback? onNotificationTap;

  const AdminWelcomeHeader({
    super.key,
    required this.adminName,
    this.profilePictureUrl,
    this.onNotificationTap,
  });

  // Tentukan BASE_URL API Anda di sini atau sebagai konstanta global
  static const String _baseUrl =
      'http://10.0.2.2:8000'; // Sesuaikan dengan IP atau domain server Anda

  @override
  Widget build(BuildContext context) {
    ImageProvider? profileImageProvider;
    if (profilePictureUrl != null && profilePictureUrl!.isNotEmpty) {
      final String fullImageUrl = profilePictureUrl!.startsWith('/')
          ? '$_baseUrl${profilePictureUrl!}'
          : '$_baseUrl/$profilePictureUrl!';
      profileImageProvider = NetworkImage(fullImageUrl);
    }

    return Container(
      // Padding ini mencakup ruang untuk status bar dan konten header
      padding: const EdgeInsets.fromLTRB(
        20.0,
        50.0,
        20.0,
        20.0,
      ), // Padding atas disesuaikan
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 230, 0), // Menggunakan AppColors.primary
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0), // Sudut melengkung di kiri bawah
          bottomRight: Radius.circular(30.0), // Sudut melengkung di kanan bawah
        ),
        boxShadow: [
          // Opsional: Tambahkan shadow untuk efek mengangkat
          BoxShadow(
            color: AppColors.black.withOpacity(0.1), // Menggunakan AppColors.black
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Ratakan semua konten Column ke kiri
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Tetap gunakan spaceBetween
            children: [
              // Dashboard Admin sekarang di posisi kiri menggantikan tombol back
              const Text(
                'Dashboard Admin', // Judul tetap
                style: TextStyle(
                  color: AppColors.white, // Warna teks putih
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Icon Notifikasi tetap di kanan
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.white, // Menggunakan AppColors.white
                  size: 28,
                ),
                onPressed: onNotificationTap,
              ),
            ],
          ),
          const SpaceHeight(
            24,
          ), // Jarak antara baris atas dan konten "Selamat Datang"
          // Konten "Selamat Datang" dan Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.white.withOpacity(0.9), // Menggunakan AppColors.white
                    ),
                  ),
                  Text(
                    adminName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white, // Menggunakan AppColors.white
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 30, // Ukuran avatar
                backgroundColor: AppColors.white.withOpacity(0.3), // Menggunakan AppColors.white
                backgroundImage: profileImageProvider,
                child: profileImageProvider == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.white, // Menggunakan AppColors.white
                        size: 30,
                      )
                    : null,
              ),
            ],
          ),
          // Bagian saldo/statistik yang Anda ingin hapus dari sini, namun tetap mempertahankan padding.
          // Jika ingin ada bagian info di bawah "Selamat Datang", bisa tambahkan di sini.
        ],
      ),
    );
  }
}