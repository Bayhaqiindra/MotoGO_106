import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/components/buttons.dart'; // Pastikan ini menyediakan Button.filled dan Button.outlined
import 'package:tugas_akhir/data/model/response/admin/profile/admin_profile_response_model.dart';

class AdminProfileViewForm extends StatelessWidget {
  final Data profileData;
  final VoidCallback onEdit;
  final VoidCallback onRefresh;
  final bool isLoading;

  const AdminProfileViewForm({
    super.key,
    required this.profileData,
    required this.onEdit,
    required this.onRefresh,
    required this.isLoading,
  });

  static const String _baseUrl = 'http://10.0.2.2:8000';

  @override
  Widget build(BuildContext context) {
    bool hasProfilePicture =
        profileData.profilePicture != null &&
        profileData.profilePicture!.isNotEmpty;

    String? fullImageUrl;
    if (hasProfilePicture) {
      final imagePath =
          profileData.profilePicture!.startsWith('/')
              ? profileData.profilePicture!
              : '/${profileData.profilePicture!}';
      fullImageUrl = '$_baseUrl$imagePath';
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Path ke gambar latar belakang Anda di folder assets.
    // GANTI 'assets/images/profile_background.png' DENGAN PATH GAMBAR ASLI ANDA!
    const String backgroundAssetPath = 'assets/images/background.jpg';

    return Stack(
      children: [
        // Latar belakang GAMBAR (hanya di bagian atas sebagai header)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.20, // Tinggi area gambar tetap
          child: Container(
            decoration: BoxDecoration(
              // Mengganti 'color' dengan 'image' untuk latar belakang gambar
              image: const DecorationImage(
                image: AssetImage(
                  backgroundAssetPath,
                ), // <--- Menggunakan AssetImage
                fit: BoxFit.cover, // Memastikan gambar menutupi seluruh area
                // Opsional: colorFilter untuk membuat teks lebih mudah dibaca di atas gambar
                colorFilter: ColorFilter.mode(
                  Colors.black54, // Overlay hitam transparan
                  BlendMode.darken, // Mode blend untuk menggelapkan gambar
                ),
              ),
            ),
          ),
        ),

        // Konten utama (nama, ID, tombol edit) dalam Container putih yang memenuhi lebar dan tinggi sisa
        Positioned(
          // Dimulai lebih tinggi, menutupi lebih banyak area gambar
          top:
              screenHeight * 0.20 -
              40, // Disesuaikan dengan tinggi gambar yang baru dan overlap yang sama
          left: 0, // Mengisi lebar penuh
          right: 0, // Mengisi lebar penuh
          bottom:
              0, // Mengisi sampai bawah layar (akan diatasi oleh padding Bottom Nav dari Scaffold induk)
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Warna background menjadi putih penuh
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), // Rounded di sudut kiri atas
                topRight: Radius.circular(30), // Rounded di sudut kanan atas
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(
                    0,
                    -5,
                  ), // Shadow ke atas agar terlihat terangkat
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ), // Padding horizontal untuk konten
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ), // Ruang di bagian atas untuk avatar (disesuaikan)
                  Text(
                    profileData.name ?? 'Nama Tidak Ada',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8), // Jarak antara nama dan ID
                  // Tombol Edit Profile
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isLoading ? null : onEdit,
                        borderRadius: BorderRadius.circular(15),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: Color(0xFF3A60C0),
                                size: 24,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Judul "Profile" di AppBar (disimulasikan)
        Positioned(
          top: statusBarHeight + 20,
          left: 24,
          child: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Avatar di tengah garis pemisah
        Positioned(
          top: screenHeight * 0.20 - 60,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    hasProfilePicture && fullImageUrl != null
                        ? NetworkImage(fullImageUrl)
                        : null,
                child:
                    !hasProfilePicture
                        ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                        : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
