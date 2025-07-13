import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/admin/sparepart/admin_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/request/admin/sparepart/update_sparepart_request_model.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/bloc/sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/admin/sparepart/widget/sparepart_form_fields.dart';

class SparepartFormPage extends StatefulWidget {
  final int?
  sparepartId; // Jika null, ini adalah operasi tambah. Jika ada, ini adalah edit.

  const SparepartFormPage({super.key, this.sparepartId});

  @override
  State<SparepartFormPage> createState() => _SparepartFormPageState();
}

class _SparepartFormPageState extends State<SparepartFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();

  File? _selectedImage;
  String? _initialImageUrl; // Untuk menyimpan URL gambar yang ada saat edit

  bool get isEditing => widget.sparepartId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      // Jika sedang mode edit, ambil data sparepart berdasarkan ID
      context.read<SparepartBloc>().add(
        FetchSparepartById(id: widget.sparepartId!),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockQuantityController.dispose();
    super.dispose();
  }

  void _onImageSelected(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        // Mode Edit
        final request = UpdateSparepartRequestModel(
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text,
          stockQuantity: _stockQuantityController.text,
          image: _selectedImage, // Mengirim gambar baru jika dipilih
        );
        context.read<SparepartBloc>().add(
          UpdateSparepart(id: widget.sparepartId!, request: request),
        );
      } else {
        // Mode Tambah
        final request = CreateSparepartRequestModel(
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text,
          stockQuantity: _stockQuantityController.text,
          image:
              _selectedImage, // Wajib ada gambar saat create jika API mewajibkan
        );
        context.read<SparepartBloc>().add(CreateSparepart(request: request));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Sparepart' : 'Tambah Sparepart'),
      ),
      body: BlocListener<SparepartBloc, SparepartState>(
        listener: (context, state) {
          if (state is SparepartByIdLoaded && isEditing) {
            // Isi form dengan data yang dimuat saat mode edit
            _nameController.text = state.sparepart.name ?? '';
            _descriptionController.text = state.sparepart.description ?? '';
            _priceController.text = state.sparepart.price?.toString() ?? '';
            _stockQuantityController.text =
                state.sparepart.stockQuantity.toString();
            _initialImageUrl =
                state.sparepart.imageUrl; // Simpan URL gambar yang ada
            setState(() {}); // Perbarui UI untuk menampilkan gambar lama
          } else if (state is SparepartCreatedSuccess) {
            // Handle SparepartCreatedSuccess
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.of(context).pop(true);
          } else if (state is SparepartUpdatedSuccess) {
            // Handle SparepartUpdatedSuccess
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.of(context).pop(true);
          } else if (state is SparepartError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: BlocBuilder<SparepartBloc, SparepartState>(
          builder: (context, state) {
            if (isEditing && state is SparepartLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SparepartFormFields(
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      priceController: _priceController,
                      stockQuantityController: _stockQuantityController,
                      initialImageUrl:
                          _initialImageUrl, // Teruskan URL gambar lama
                      onImageSelected: _onImageSelected,
                    ),
                    const SizedBox(height: 20),
                    if (state
                        is SparepartLoading) // Tampilkan loading saat submit
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          isEditing ? 'Simpan Perubahan' : 'Tambah Sparepart',
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
