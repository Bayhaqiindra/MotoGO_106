import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan dependency: image_picker
import 'package:tugas_akhir/data/model/request/pelanggan/payment_sparepart/submit_payment_sparepart_request_model.dart';
import 'dart:io';
import 'package:tugas_akhir/presentation/pelanggan/payment_sparepart/bloc/pelanggan_payment_sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/widget/riwayat_transaction_page.dart'; // Untuk navigasi final

class PaymentSparepartPage extends StatefulWidget {
  final int transactionId; // ID transaksi yang perlu dibayar
  final String transactionTotalPrice; // Total harga transaksi

  const PaymentSparepartPage({
    Key? key,
    required this.transactionId,
    required this.transactionTotalPrice,
  }) : super(key: key);

  @override
  State<PaymentSparepartPage> createState() => _PaymentSparepartPageState();
}

class _PaymentSparepartPageState extends State<PaymentSparepartPage> {
  String? _selectedMethod;
  File? _buktiPembayaranFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _buktiPembayaranFile = File(pickedFile.path);
      });
    }
  }

  void _submitPayment() {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu.')),
      );
      return;
    }

    if (_selectedMethod == 'transfer' && _buktiPembayaranFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unggah bukti pembayaran untuk metode transfer.')),
      );
      return;
    }

    final requestModel = SubmitPaymentSparepartRequestModel(
      transactionId: widget.transactionId,
      metodePembayaran: _selectedMethod!,
      buktiPembayaran: _buktiPembayaranFile, // Akan null jika metode cash
    );

    // Kirim event ke BLoC
    context.read<PelangganPaymentSparepartBloc>().add(
          SubmitPelangganPaymentSparepart(requestModel),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Sparepart'),
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<PelangganPaymentSparepartBloc, PelangganPaymentSparepartState>(
        listener: (context, state) {
          if (state is PelangganPaymentSparepartLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is PelangganPaymentSparepartSubmitSuccess) {
            Navigator.pop(context); // Tutup dialog loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pembayaran berhasil: ${state.response.message}')),
            );
            // Navigasi ke halaman riwayat transaksi setelah sukses
            // Hapus semua rute sebelumnya hingga root, lalu push RiwayatTransactionPage
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const RiwayatTransactionPage()),
              (route) => route.isFirst,
            );
          } else if (state is PelangganPaymentSparepartError) {
            Navigator.pop(context); // Tutup dialog loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Pembayaran:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Rp ${widget.transactionTotalPrice}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                      const Divider(height: 24),
                      Text(
                        'Pilih Metode Pembayaran:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      RadioListTile<String>(
                        title: const Text('Transfer Bank'),
                        value: 'transfer',
                        groupValue: _selectedMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedMethod = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Cash'),
                        value: 'cod',
                        groupValue: _selectedMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedMethod = value;
                            _buktiPembayaranFile = null; // Hapus bukti pembayaran jika metode cash
                          });
                        },
                      ),
                      if (_selectedMethod == 'transfer') ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Unggah Bukti Pembayaran'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A60C0),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        if (_buktiPembayaranFile != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'File terpilih: ${_buktiPembayaranFile!.path.split('/').last}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A60C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Bayar Sekarang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}