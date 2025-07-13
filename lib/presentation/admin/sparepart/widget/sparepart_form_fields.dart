import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SparepartFormFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController stockQuantityController;
  final String? initialImageUrl; // Untuk menampilkan gambar yang sudah ada saat edit
  final Function(File?) onImageSelected; // Callback saat gambar dipilih

  const SparepartFormFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.stockQuantityController,
    this.initialImageUrl,
    required this.onImageSelected,
  });

  @override
  State<SparepartFormFields> createState() => _SparepartFormFieldsState();
}

class _SparepartFormFieldsState extends State<SparepartFormFields> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Jika ada initialImageUrl, kita tidak perlu set _selectedImage di sini
    // karena ini hanya untuk gambar baru yang akan diupload.
    // InitialImageUrl akan ditangani di tampilan gambar.
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(context); // Tutup bottom sheet
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                    widget.onImageSelected(_selectedImage);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context); // Tutup bottom sheet
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                    widget.onImageSelected(_selectedImage);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: 'Nama Sparepart',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama sparepart tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: widget.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Deskripsi',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Deskripsi tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: widget.priceController,
          decoration: const InputDecoration(
            labelText: 'Harga',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harga tidak boleh kosong';
            }
            if (double.tryParse(value) == null) {
              return 'Harga harus angka';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: widget.stockQuantityController,
          decoration: const InputDecoration(
            labelText: 'Jumlah Stok',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Jumlah stok tidak boleh kosong';
            }
            if (int.tryParse(value) == null) {
              return 'Jumlah stok harus angka bulat';
            }
            return null;
          },
        ),
const SizedBox(height: 16),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  )
                : (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty)
                    ? Image.network(
                        'http://10.0.2.2:8000/storage/${widget.initialImageUrl}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap untuk memilih/mengambil gambar',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}