import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart';
import 'package:tugas_akhir/core/components/spaces.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/pelanggan_profile_response_model.dart';

class PelangganProfileInputForm extends StatefulWidget {
  final bool isUpdateMode;
  final Data? initialData;
  final Function(String name, String phone, String address, File? image) onSubmit;
  final bool isLoading;

  const PelangganProfileInputForm({
    super.key,
    required this.isUpdateMode,
    this.initialData,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<PelangganProfileInputForm> createState() => _PelangganProfileInputFormState();
}

class _PelangganProfileInputFormState extends State<PelangganProfileInputForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateMode && widget.initialData != null) {
      nameController.text = widget.initialData!.name ?? '';
      phoneController.text = widget.initialData!.phone ?? '';
      addressController.text = widget.initialData!.address ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.isUpdateMode ? 'Perbarui Profil' : 'Lengkapi Profil',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SpaceHeight(16),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null
                  ? const Icon(Icons.camera_alt, size: 32)
                  : null,
            ),
          ),
          const SpaceHeight(16),
          CustomTextField(
            controller: nameController,
            label: 'Nama Lengkap',
            validator: 'Nama tidak boleh kosong',
          ),
          const SpaceHeight(16),
          CustomTextField(
            controller: phoneController,
            label: 'No HP',
            keyboardType: TextInputType.phone,
            validator: 'Nomor HP tidak boleh kosong',
          ),
          const SpaceHeight(16),
          CustomTextField(
            controller: addressController,
            label: 'Alamat',
            maxLines: 3,
            validator: 'Alamat tidak boleh kosong',
          ),
          const SpaceHeight(24),
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
            label: widget.isUpdateMode ? 'Perbarui' : 'Simpan',
            disabled: widget.isLoading,
          )
        ],
      ),
    );
  }
}
