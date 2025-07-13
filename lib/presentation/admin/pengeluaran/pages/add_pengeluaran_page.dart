import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/admin/pengeluaran/add_pengeluaran_request_model.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart'; // Menggunakan CustomTextField yang baru

class AddPengeluaranPage extends StatefulWidget {
  const AddPengeluaranPage({super.key});

  @override
  State<AddPengeluaranPage> createState() => _AddPengeluaranPageState();
}

class _AddPengeluaranPageState extends State<AddPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _jumlahController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final request = AddPengeluaranRequestModel(
        categoryPengeluaran: _categoryController.text,
        jumlahPengeluaran: int.tryParse(_jumlahController.text),
        deskripsiPengeluaran: _deskripsiController.text,
      );
      context.read<PengeluaranBloc>().add(AddPengeluaran(request: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
        backgroundColor: Color(0xFFDCCBAF),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: BlocListener<PengeluaranBloc, PengeluaranState>(
        listener: (context, state) {
          if (state is PengeluaranAdded) {
            Navigator.pop(context);
          } else if (state is PengeluaranError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                CustomTextField( // Menggunakan CustomTextField
                  controller: _categoryController,
                  label: 'Kategori Pengeluaran', // Menggunakan 'label' bukan 'labelText'
                  prefixIcon: const Icon(Icons.category_outlined, color: Color.fromARGB(255, 0, 0, 0)), // Contoh ikon
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kategori tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField( // Menggunakan CustomTextField
                  controller: _jumlahController,
                  label: 'Jumlah Pengeluaran', // Menggunakan 'label'
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.attach_money_outlined, color: Color.fromARGB(255, 41, 41, 41)), // Contoh ikon
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField( // Menggunakan CustomTextField
                  controller: _deskripsiController,
                  label: 'Deskripsi Pengeluaran', // Menggunakan 'label'
                  maxLines: 3,
                  prefixIcon: const Icon(Icons.description_outlined, color: Color.fromARGB(255, 0, 0, 0)), // Contoh ikon
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDCCBAF),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: BlocBuilder<PengeluaranBloc, PengeluaranState>(
                    builder: (context, state) {
                      return state is PengeluaranLoading
                          ? const CircularProgressIndicator(color: Color.fromARGB(255, 0, 0, 0))
                          : const Text(
                              'Tambah Pengeluaran',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}