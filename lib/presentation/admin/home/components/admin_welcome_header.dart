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

    // Path ke gambar latar belakang Anda di folder assets.
    // GANTI 'assets/images/background_header.png' DENGAN PATH GAMBAR ASLI ANDA!
    const String backgroundAssetPath = 'assets/images/background.jpg';
    return Container(
      padding: EdgeInsets.fromLTRB(
        Spaces.horizontalMedium.width,
        MediaQuery.of(context).padding.top + 20.0, // Padding atas disesuaikan dengan status bar
        Spaces.horizontalMedium.width,
        Spaces.verticalMedium.height,
      ),
      decoration: BoxDecoration(
        // Mengganti 'color' dengan 'image' untuk latar belakang gambar
        image: const DecorationImage(
          image: AssetImage(backgroundAssetPath), // <--- Menggunakan AssetImage
          fit: BoxFit.cover, // Memastikan gambar menutupi seluruh area
          // Opsional: colorFilter untuk membuat teks lebih mudah dibaca di atas gambar
          colorFilter: ColorFilter.mode(
            Colors.black54, // Overlay hitam transparan
            BlendMode.darken, // Mode blend untuk menggelapkan gambar
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0), // Sudut melengkung di kiri bawah
          bottomRight: Radius.circular(30.0), // Sudut melengkung di kanan bawah
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1), // Menggunakan AppColors.black
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dashboard Admin',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.white,
                  size: 28,
                ),
                onPressed: onNotificationTap,
                tooltip: 'Notifications',
              ),
            ],
          ),
          Spaces.verticalMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      adminName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Spaces.horizontalMedium,
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.white.withOpacity(0.3),
                backgroundImage: profileImageProvider,
                child: profileImageProvider == null
                    ? const Icon(
                        Icons.person_outline,
                        color: AppColors.white,
                        size: 30,
                      )
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}