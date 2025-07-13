import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/constants/colors.dart'; // Import AppColors
import 'package:tugas_akhir/data/model/response/pelanggan/profile/pelanggan_profile_response_model.dart';

class PelangganProfileViewForm extends StatelessWidget {
  final Data profileData;
  final VoidCallback onEdit;
  final VoidCallback onRefresh; // onRefresh masih diperlukan untuk konstruktor, meskipun tombolnya dihapus
  final bool isLoading;

  const PelangganProfileViewForm({
    super.key,
    required this.profileData,
    required this.onEdit,
    required this.onRefresh, // Tetap diperlukan di sini
    required this.isLoading,
  });

  // Base URL untuk gambar profil (sesuaikan dengan backend Anda)
  // PASTIKAN INI SESUAI DENGAN BASE URL API ANDA YANG MENGEMBALIKAN GAMBAR PROFIL
  static const String _baseUrl = 'http://10.0.2.2:8000'; // Contoh: GANTI DENGAN BASE URL API ANDA

  @override
  Widget build(BuildContext context) {
    debugPrint('[DEBUG] Profile picture URL: ${profileData.profilePicture}');

    bool hasProfilePicture = profileData.profilePicture != null &&
        profileData.profilePicture!.isNotEmpty;

    String? fullImageUrl;
    if (hasProfilePicture) {
      // Memeriksa apakah profilePicture sudah merupakan URL lengkap
      if (profileData.profilePicture!.startsWith('http://') || profileData.profilePicture!.startsWith('https://')) {
        fullImageUrl = profileData.profilePicture!;
      } else {
        // Jika hanya path relatif, pastikan path dimulai dengan '/' dan tambahkan base URL
        final imagePath = profileData.profilePicture!.startsWith('/')
            ? profileData.profilePicture!
            : '/${profileData.profilePicture!}';
        fullImageUrl = '$_baseUrl$imagePath';
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;

    // Path ke gambar latar belakang Anda di folder assets.
    // GANTI 'assets/images/background.jpg' DENGAN PATH GAMBAR ASLI ANDA!
    const String backgroundAssetPath = 'assets/images/background.jpg'; // Contoh gambar latar belakang

    return Stack(
      children: [
        // Latar belakang GAMBAR (hanya di bagian atas sebagai header)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.20, // Tinggi area gambar sama dengan admin
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundAssetPath), // Menggunakan AssetImage
                fit: BoxFit.cover, // Memastikan gambar menutupi seluruh area
                colorFilter: ColorFilter.mode(
                  Colors.black54, // Overlay hitam transparan untuk teks lebih mudah dibaca
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        ),

        // Konten utama (nama, detail, tombol) dalam Container putih yang mengambang
        Positioned(
          top: screenHeight * 0.20 - 40, // Posisi awal kartu, overlap dengan gambar
          left: 0,
          right: 0,
          bottom: 0, // Mengisi sampai bawah layar
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white, // Warna background menjadi putih penuh
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), // Rounded di sudut kiri atas
                topRight: Radius.circular(30), // Rounded di sudut kanan atas
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, -5), // Shadow ke atas agar terlihat terangkat
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ), // Padding horizontal untuk konten
              child: Column(
                children: [
                  // Mengubah nilai height dari 80 menjadi 100 untuk menambah jarak antara avatar dan nama
                  const SizedBox(height: 100), // Ruang di bagian atas untuk avatar (sesuaikan)
                  Text(
                    profileData.name ?? 'Nama Tidak Ada',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith( // Ukuran font lebih besar
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                  ),
                  const SizedBox(height: 8), 
                  // Perubahan: Jarak di sini (antara nama dan ID pelanggan) akan terlihat sebagai jarak antara nama dan detail pertama di dalam kartu putih.
                  // Jarak setelah ID pelanggan sebelum info detail
                  _buildInfo(context, Icons.phone_outlined, "Telepon", profileData.phone ?? '-'),
                  _buildInfo(context, Icons.location_on_outlined, "Alamat", profileData.address ?? '-'),
                  const SpaceHeight(32),
                  Button.filled(
                    onPressed: isLoading ? null : onEdit,
                    label: 'Edit Profil',
                    color: AppColors.primary,
                    textColor: AppColors.white,
                  ),
                  // Tombol "Refresh" telah dihapus
                  const SpaceHeight(20), // Padding bawah untuk BottomNavBar
                ],
              ),
            ),
          ),
        ),

        // Avatar di tengah garis pemisah
        Positioned(
          top: screenHeight * 0.20 - 60, // Posisi avatar agar overlap dengan header dan kartu (sama dengan admin)
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              radius: 60, // Radius sama dengan admin
              backgroundColor: AppColors.white, // Border putih
              child: CircleAvatar(
                radius: 55, // Radius gambar profil sebenarnya
                backgroundColor: AppColors.lightGrey,
                backgroundImage: hasProfilePicture && fullImageUrl != null
                    ? NetworkImage(fullImageUrl)
                    : null,
                child: !hasProfilePicture
                    ? Icon(Icons.person, size: 60, color: AppColors.grey)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.darkGrey),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
              ),
            ],
          ),
          const SpaceHeight(8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGrey, width: 1),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
