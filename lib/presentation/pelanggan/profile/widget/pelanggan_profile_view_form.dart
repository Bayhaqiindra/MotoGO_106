import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/profile/pelanggan_profile_response_model.dart';

class PelangganProfileViewForm extends StatelessWidget {
  final Data profileData;
  final VoidCallback onEdit;
  final VoidCallback onRefresh;
  final bool isLoading;

  const PelangganProfileViewForm({
    super.key,
    required this.profileData,
    required this.onEdit,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Tambahkan debug
    debugPrint('[DEBUG] Profile picture URL: ${profileData.profilePicture}');

    bool hasProfilePicture = profileData.profilePicture != null &&
        profileData.profilePicture!.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Profil Anda',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SpaceHeight(16),
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundImage: hasProfilePicture
                ? NetworkImage(profileData.profilePicture!)
                : null,
            child: !hasProfilePicture
                ? const Icon(Icons.person, size: 32)
                : null,
          ),
        ),
        if (!hasProfilePicture)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '[DEBUG] Tidak ada gambar profil ditemukan.',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        const SpaceHeight(24),
        _buildInfo("Nama", profileData.name ?? '-'),
        _buildInfo("Telepon", profileData.phone ?? '-'),
        _buildInfo("Alamat", profileData.address ?? '-'),
        const SpaceHeight(24),
        Button.filled(
          onPressed: isLoading ? null : onEdit,
          label: 'Edit Profil',
        ),
        const SpaceHeight(16),
        Button.outlined(
          onPressed: isLoading ? null : onRefresh,
          label: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SpaceHeight(4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
