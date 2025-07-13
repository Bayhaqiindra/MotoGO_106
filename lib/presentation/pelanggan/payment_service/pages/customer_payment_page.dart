// lib/presentation/pelanggan/payment/pages/customer_payment_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Asumsikan Anda memiliki BLoC atau Cubit untuk Payment Service
import 'package:tugas_akhir/core/extensions/loading_payment.dart'; // Pastikan LoadingPayment sudah dimodifikasi seperti saran sebelumnya
import 'package:tugas_akhir/data/model/request/pelanggan/payment_service/pelanggan_payment_service_request_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/payment_service/bloc/pelanggan_payment_service_bloc.dart'; // Sesuaikan path BLoC Anda
import 'package:tugas_akhir/presentation/pelanggan/history/pages/customer_history_combined_page.dart'; // Import halaman riwayat

class CustomerPaymentPage extends StatefulWidget {
  final int transactionId; // ID transaksi untuk pembayaran ini
  final String transactionTotalPrice; // Total harga yang harus dibayar

  const CustomerPaymentPage({
    Key? key,
    required this.transactionId,
    required this.transactionTotalPrice,
  }) : super(key: key);

  @override
  State<CustomerPaymentPage> createState() => _CustomerPaymentPageState();
}

class _CustomerPaymentPageState extends State<CustomerPaymentPage> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  String? _selectedMetodePembayaran;

  @override
  void initState() {
    super.initState();
    // Anda bisa set default di sini jika mau
    // _selectedMetodePembayaran = 'transfer';
  }

  // --- FUNGSI _pickImage() YANG DIMODIFIKASI ---
  Future<void> _pickImage() async {
    // Tampilkan bottom sheet untuk pilihan sumber gambar
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.of(context).pop(); // Tutup bottom sheet
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  _handlePickedFile(pickedFile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.of(context).pop(); // Tutup bottom sheet
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  _handlePickedFile(pickedFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi pembantu untuk menangani file yang dipilih
  void _handlePickedFile(XFile? pickedFile) {
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada gambar yang dipilih.')),
      );
    }
  }

  void _submitPayment() {
    // Validasi apakah metode pembayaran sudah dipilih
    if (_selectedMetodePembayaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih metode pembayaran.')),
      );
      return;
    }

    // Hanya validasi gambar jika metode pembayaran adalah 'transfer'
    if (_selectedMetodePembayaran == 'transfer' && _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon unggah bukti pembayaran untuk metode transfer.')),
      );
      return;
    }

    // Panggil event untuk mengirim pembayaran
    context.read<PelangganPaymentServiceBloc>().add(
          SubmitPelangganPaymentService(
            request: PelangganPaymentServiceRequestModel(
              confirmationId: widget.transactionId,
              metodePembayaran: _selectedMetodePembayaran!, // <-- Gunakan nilai dari state
              buktiPembayaran: _pickedImage, // Bisa null jika COD
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Layanan'),
      ),
      body: BlocConsumer<PelangganPaymentServiceBloc, PelangganPaymentServiceState>(
        listener: (context, state) {
          if (state is PelangganPaymentServiceLoading) {
            if (mounted) LoadingPayment.show(context);
          } else {
            if (mounted) LoadingPayment.hide(context);
          }

          if (state is PelangganPaymentServiceSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response.message ?? 'Pembayaran berhasil dikirim! ✅')),
            );
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const CustomerHistoryPage()),
                (Route<dynamic> route) => false,
              );
            }
          } else if (state is PelangganPaymentServiceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal mengirim pembayaran: ${state.error} ❌')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Pembayaran untuk Transaksi ID: ${widget.transactionId}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total yang Harus Dibayar: ${widget.transactionTotalPrice}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 24),

                // --- Pilihan Metode Pembayaran ---
                const Text(
                  'Pilih Metode Pembayaran:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                RadioListTile<String>(
                  title: const Text('Transfer Bank'),
                  value: 'transfer',
                  groupValue: _selectedMetodePembayaran,
                  onChanged: (value) {
                    setState(() {
                      _selectedMetodePembayaran = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Cash On Delivery (COD)'),
                  value: 'cod',
                  groupValue: _selectedMetodePembayaran,
                  onChanged: (value) {
                    setState(() {
                      _selectedMetodePembayaran = value;
                      // Jika memilih COD, reset gambar yang dipilih karena tidak diperlukan
                      if (value == 'cod') {
                        _pickedImage = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),

                // --- Bagian Unggah Bukti Pembayaran (Hanya jika 'transfer' dipilih) ---
                if (_selectedMetodePembayaran == 'transfer') ...[
                  const Text(
                    'Silakan unggah bukti pembayaran Anda:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: _pickedImage == null
                        ? Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: InkWell(
                              onTap: _pickImage,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 50, color: Colors.grey[600]),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pilih Gambar',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Image.file(
                            _pickedImage!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Ubah Bukti Pembayaran'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                // --- Akhir Bagian Unggah Bukti Pembayaran ---

                ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Kirim Pembayaran'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}