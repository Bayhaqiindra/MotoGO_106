import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/admin/pengeluaran/update_pengeluaran_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/get_all_pengeluaran_response_model.dart';
import 'package:tugas_akhir/presentation/admin/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart'; // Menggunakan CustomTextField yang baru

class EditPengeluaranPage extends StatefulWidget {
  final int pengeluaranId;
  final Datum initialData; // Data awal pengeluaran yang akan diedit

  const EditPengeluaranPage({
    Key? key,
    required this.pengeluaranId,
    required this.initialData,
  }) : super(key: key);

  @override
  State<EditPengeluaranPage> createState() => _EditPengeluaranPageState();
}

class _EditPengeluaranPageState extends State<EditPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryController;
  late TextEditingController _jumlahController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _categoryController =
        TextEditingController(text: widget.initialData.categoryPengeluaran);
    _jumlahController =
        TextEditingController(text: widget.initialData.jumlahPengeluaran);
    _deskripsiController =
        TextEditingController(text: widget.initialData.deskripsiPengeluaran);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _jumlahController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final request = UpdatePengeluaranRequestModel(
        categoryPengeluaran: _categoryController.text,
        jumlahPengeluaran: int.tryParse(_jumlahController.text),
        deskripsiPengeluaran: _deskripsiController.text,
      );
      context
          .read<PengeluaranBloc>()
          .add(UpdatePengeluaran(id: widget.pengeluaranId, request: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengeluaran'),
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
          if (state is PengeluaranUpdated) {
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
                  label: 'Kategori Pengeluaran', // Menggunakan 'label'
                  prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFFDCCBAF)), // Contoh ikon
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
                  prefixIcon: const Icon(Icons.attach_money_outlined, color: Color(0xFFDCCBAF)), // Contoh ikon
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
                  prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFFDCCBAF)), // Contoh ikon
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
                    foregroundColor: const Color.fromARGB(255, 11, 8, 8),
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
                              'Simpan Perubahan',
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