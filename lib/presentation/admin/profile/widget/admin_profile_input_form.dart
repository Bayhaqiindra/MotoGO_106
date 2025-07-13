import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/data/model/response/admin/profile/admin_profile_response_model.dart';

class AdminProfileInputForm extends StatefulWidget {
  final bool isUpdateMode;
  final AdminProfileResponseModel? initialData;
  final Function(String name, File? image) onSubmit;
  final bool isLoading;

  const AdminProfileInputForm({
    super.key,
    required this.isUpdateMode,
    this.initialData,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<AdminProfileInputForm> createState() => _AdminProfileInputFormState();
}

class _AdminProfileInputFormState extends State<AdminProfileInputForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  File? _imageFile;
  String? _currentProfilePictureUrl;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateMode && widget.initialData != null) {
      nameController.text = widget.initialData!.data?.name ?? '';
      _currentProfilePictureUrl = widget.initialData!.data?.profilePicture;
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
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
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
        _currentProfilePictureUrl = null;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;
    if (_imageFile != null) {
      backgroundImage = FileImage(_imageFile!);
    } else if (_currentProfilePictureUrl != null && _currentProfilePictureUrl!.isNotEmpty) {
      final String fullImageUrl = 'http://10.0.2.2:8000${_currentProfilePictureUrl!}';
      backgroundImage = NetworkImage(fullImageUrl);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.isUpdateMode ? 'Perbarui Profil Admin' : 'Lengkapi Profil Admin',
          style: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80,
        elevation: 10,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFDCCBAF),
                Color(0xFFDCCBAF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                const SpaceHeight(32),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: backgroundImage,
                        child: backgroundImage == null
                            ? Icon(
                                Icons.person_outline,
                                size: 60,
                                color: Colors.grey[400],
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImageSourceOptions, // <--- Panggil fungsi baru di sini
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).colorScheme.onSecondary,
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
                  label: 'Nama Admin',
                  hintText: 'Masukkan nama lengkap admin',
                  prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.primary),
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Nama tidak boleh kosong'
                          : null,
                ),
                const SpaceHeight(40),
                Button.filled(
                  onPressed: widget.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            widget.onSubmit(nameController.text, _imageFile);
                          }
                        },
                  label: widget.isUpdateMode ? 'Perbarui Profil' : 'Simpan Profil',
                  disabled: widget.isLoading,
                  color: const Color(0xFF3A60C0),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
