// lib/presentation/pelanggan/transaction/pages/transaction_confirmation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_by_id_sparepart_response_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/payment_sparepart/pages/payment_sparepart_page.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/bloc/transaction_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/widget/riwayat_transaction_page.dart';

class TransactionConfirmationPage extends StatelessWidget {
  final GetSparepartByIdResponseModel sparepart;
  final int quantity;

  const TransactionConfirmationPage({
    super.key,
    required this.sparepart,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    // ✨ PERBAIKAN 1: Pastikan fallback untuk totalPrice adalah 0.0 (double) ✨
    final double totalPrice = (double.tryParse(sparepart.price?.toString() ?? '0') ?? 0.0) * quantity;

    // ✨ PERBAIKAN 2: Definisikan base URL untuk gambar ✨
    // Ganti dengan base URL server backend Anda yang sebenarnya
    // Contoh untuk emulator Android: 'http://10.0.2.2:8000'
    // Contoh untuk perangkat fisik di jaringan lokal: 'http://<IP_KOMPUTER_ANDA>:8000'
    const String baseUrlForImages = 'http://10.0.2.2:8000';

    // ✨ PERBAIKAN 3: Bangun URL gambar lengkap ✨
    String imageUrlToDisplay = sparepart.imageUrl ?? ''; // Inisialisasi dengan string kosong
    if (sparepart.imageUrl != null && sparepart.imageUrl!.isNotEmpty) {
      if (sparepart.imageUrl!.startsWith('http://') || sparepart.imageUrl!.startsWith('https://')) {
        // Jika URL sudah lengkap
        imageUrlToDisplay = sparepart.imageUrl!;
      } else {
        // Jika hanya path relatif, gabungkan dengan base URL
        imageUrlToDisplay = '$baseUrlForImages/storage/${sparepart.imageUrl}';
      }
    } else {
      // Jika imageUrl null atau kosong, gunakan placeholder lokal
      imageUrlToDisplay = 'assets/images/no_image.png'; // Pastikan path ini ada di pubspec.yaml
    }

    // Optional: Log URL gambar final untuk debugging
    print('Final Image URL to display in TransactionConfirmationPage: $imageUrlToDisplay');


    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pembelian'),
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionLoading) {
            // Tampilkan loading dialog atau indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AddTransactionSuccess) {
            Navigator.pop(context); // Tutup dialog loading
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaksi berhasil dibuat! Lanjutkan ke pembayaran.')),
            );
            // Navigasi ke halaman riwayat transaksi setelah sukses
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSparepartPage(
                  transactionId: state.transaction.data!.transactionId!, // Asumsi ada 'data' di dalam model respons
                  transactionTotalPrice: state.transaction.data!.totalPrice!.toString(),
                ),
              ),
            );
          } else if (state is AddTransactionError) {
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
                        'Detail Produk:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // ✨ PERBAIKAN 4: Gunakan imageUrlToDisplay yang sudah dibangun ✨
                          // Menggunakan Image.network atau Image.asset berdasarkan URL
                          imageUrlToDisplay.startsWith('http')
                              ? Image.network(
                                  imageUrlToDisplay,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading network image: $error');
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                    );
                                  },
                                )
                              : Image.asset(
                                  imageUrlToDisplay, // Ini akan menjadi 'assets/images/no_image.png'
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading asset image: $error');
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                    );
                                  },
                                ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sparepart.name ?? 'Nama Sparepart',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Harga Satuan: Rp ${sparepart.price?.toStringAsFixed(0) ?? '0'}',
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Jumlah Beli: $quantity',
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Harga:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp ${totalPrice.toStringAsFixed(0)}', // Format harga
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TransactionBloc>().add(
                          AddNewTransaction(
                            sparepartId: sparepart.sparepartId!, // Pastikan ID tidak null
                            quantity: quantity,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A60C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Selesaikan Pembelian',
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