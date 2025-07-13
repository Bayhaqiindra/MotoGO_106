import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/core/constants/colors.dart'; // Import AppColors
import 'package:tugas_akhir/data/model/response/pelanggan/profile/pelanggan_profile_response_model.dart';

class PelangganProfileInputForm extends StatefulWidget {
  final bool isUpdateMode;
  final Data? initialData;
  final Function(String name, String phone, String address, File? image)
      onSubmit;
  final bool isLoading;

  const PelangganProfileInputForm({
    super.key,
    required this.isUpdateMode,
    this.initialData,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<PelangganProfileInputForm> createState() =>
      _PelangganProfileInputFormState();
}

class _PelangganProfileInputFormState extends State<PelangganProfileInputForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  File? _imageFile;
  String? _currentProfilePictureUrl; // Untuk menyimpan URL gambar profil yang sudah ada

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateMode && widget.initialData != null) {
      nameController.text = widget.initialData!.name ?? '';
      phoneController.text = widget.initialData!.phone ?? '';
      addressController.text = widget.initialData!.address ?? '';
      _currentProfilePictureUrl = widget.initialData!.profilePicture; // Ambil URL gambar yang sudah ada
    }
  }

  // Fungsi untuk menampilkan opsi pemilihan gambar (kamera/galeri)
  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk memilih gambar dari sumber tertentu
  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _currentProfilePictureUrl = null; // Hapus URL lama jika memilih gambar baru
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;
    if (_imageFile != null) {
      backgroundImage = FileImage(_imageFile!);
    } else if (widget.isUpdateMode && _currentProfilePictureUrl != null && _currentProfilePictureUrl!.isNotEmpty) {
      // Asumsi URL gambar profil lengkap sudah ada atau perlu ditambahkan base URL jika diperlukan
      // Contoh: final String fullImageUrl = 'http://your_base_url/${_currentProfilePictureUrl!}';
      backgroundImage = NetworkImage(_currentProfilePictureUrl!);
    }

    return Form(
      key: _formKey,
      child: Material( // Membungkus dengan Material untuk shadow dan border radius
        color: AppColors.white, // Background putih untuk form
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              const SpaceHeight(32), // Ruang di bagian atas
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: AppColors.lightGrey,
                      backgroundImage: backgroundImage,
                      child: backgroundImage == null
                          ? Icon(
                              Icons.person_outline,
                              size: 60,
                              color: AppColors.grey,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceOptions, // Panggil fungsi baru di sini
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary, // Warna ikon kamera
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 3),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceHeight(32),
              CustomTextField(
                controller: nameController,
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap Anda',
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SpaceHeight(16),
              CustomTextField(
                controller: phoneController,
                label: 'No HP',
                hintText: 'Masukkan nomor HP Anda',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nomor HP tidak boleh kosong'
                    : null,
              ),
              const SpaceHeight(16),
              CustomTextField(
                controller: addressController,
                label: 'Alamat',
                hintText: 'Masukkan alamat lengkap Anda',
                maxLines: 3,
                prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                validator: (value) => value == null || value.isEmpty
                    ? 'Alamat tidak boleh kosong'
                    : null,
              ),
              const SpaceHeight(40),
              Button.filled(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSubmit(
                            nameController.text,
                            phoneController.text,
                            addressController.text,
                            _imageFile,
                          );
                        }
                      },
                label: widget.isUpdateMode ? 'Perbarui Profil' : 'Simpan Profil',
                disabled: widget.isLoading,
                color: AppColors.primary,
                textColor: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
