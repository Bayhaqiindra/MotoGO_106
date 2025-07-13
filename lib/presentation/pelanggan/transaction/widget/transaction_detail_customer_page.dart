// lib/presentation/pelanggan/transaction/pages/transaction_detail_customer_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/bloc/transaction_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class TransactionDetailCustomerPage extends StatefulWidget {
  final int transactionId;

  const TransactionDetailCustomerPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailCustomerPage> createState() => _TransactionDetailCustomerPageState();
}

class _TransactionDetailCustomerPageState extends State<TransactionDetailCustomerPage> {
  // Base URL kini mencakup '/storage' untuk URL gambar Laravel yang benar.
  static const String _baseUrl = 'http://10.0.2.2:8000/storage';

  @override
  void initState() {
    super.initState();
    // Memanggil event untuk mengambil detail transaksi saat halaman diinisialisasi.
    context.read<TransactionBloc>().add(FetchTransactionDetail(transactionId: widget.transactionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        backgroundColor: const Color(0xFF3A60C0), // Warna latar belakang AppBar
        foregroundColor: Colors.white, // Warna teks di AppBar
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          // Menampilkan indikator loading jika state adalah TransactionLoading
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Menampilkan detail transaksi jika state adalah TransactionDetailLoaded
          else if (state is TransactionDetailLoaded) {
            final transaction = state.transactionDetail.data;

            // Menangani kasus di mana data transaksi kosong
            if (transaction == null) {
              return const Center(child: Text('Data transaksi tidak ditemukan.'));
            }

            // Fungsi helper untuk memformat tanggal
            String formatDate(DateTime? date) {
              return date == null ? '-' : DateFormat('dd MMMM yyyy, HH:mm').format(date.toLocal());
            }

            // Fungsi helper untuk memformat mata uang
            String formatCurrency(String? price) {
              if (price == null) return 'Rp 0';
              try {
                final double amount = double.parse(price);
                final NumberFormat formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
                return formatter.format(amount);
              } catch (e) {
                // Log error jika parsing harga gagal
                print('DEBUG: TransactionDetailCustomerPage: Error parsing price "$price": $e');
                return 'Rp $price'; // Fallback jika parsing gagal
              }
            }

            // Fungsi helper untuk mendapatkan URL gambar sparepart lengkap
            String getSparepartImageUrl(String? path) {
              if (path == null || path.isEmpty) {
                return ''; // Mengembalikan string kosong jika path tidak ada
              }
              // Jika path sudah berupa URL lengkap, langsung kembalikan
              if (path.startsWith('http://') || path.startsWith('https://')) {
                return path;
              } else {
                // Menggabungkan base URL dengan path relatif sparepart
                final imagePath = path.startsWith('/') ? path : '/$path';
                final fullUrl = '$_baseUrl$imagePath';
                return fullUrl;
              }
            }

            final imageUrl = getSparepartImageUrl(transaction.sparepart?.imageUrl);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Transaksi ID: ${transaction.transactionId ?? '-'}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3A60C0)),
                        ),
                      ),
                      const Divider(height: 30, thickness: 1),
                      // Baris detail untuk Tanggal Transaksi
                      _buildDetailRow(
                        'Tanggal Transaksi:',
                        formatDate(transaction.transactionDate),
                        Icons.calendar_today,
                      ),
                      // Baris detail untuk Total Harga
                      _buildDetailRow(
                        'Total Harga:',
                        formatCurrency(transaction.totalPrice),
                        Icons.payments,
                        valueColor: Colors.green,
                        valueWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Informasi Sparepart:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      const Divider(),
                      // Menampilkan informasi sparepart jika tersedia
                      if (transaction.sparepart != null) ...[
                        Center(
                          child: Column(
                            children: [
                              // Menampilkan gambar sparepart dari network atau placeholder
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      // Error builder untuk menangani kegagalan memuat gambar
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 120,
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                                Text(
                                                  'Gagal memuat gambar',
                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                              // Baris Text yang menampilkan URL gambar telah dihapus dari sini.
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Baris detail untuk Nama Sparepart
                        _buildDetailRow(
                          'Nama Sparepart:',
                          transaction.sparepart!.name ?? '-',
                          Icons.build,
                        ),
                        // Baris detail untuk Deskripsi Sparepart
                        _buildDetailRow(
                          'Deskripsi:',
                          transaction.sparepart!.description ?? '-',
                          Icons.description,
                        ),
                        // Baris detail untuk Harga Satuan Sparepart
                        _buildDetailRow(
                          'Harga Satuan:',
                          formatCurrency(transaction.sparepart!.price),
                          Icons.attach_money,
                        ),
                        // Baris detail untuk Jumlah Beli Sparepart
                        _buildDetailRow(
                          'Jumlah Beli:',
                          '${transaction.quantity ?? 0}',
                          Icons.add_shopping_cart,
                        ),
                      ] else ...[
                        const Text('Informasi sparepart tidak tersedia.'),
                      ],
                      const SizedBox(height: 20),
                      Text(
                        'Informasi Pelanggan:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      const Divider(),
                      // Menampilkan informasi pelanggan jika tersedia
                      if (transaction.user != null) ...[
                        // Baris detail untuk Email Pelanggan
                        _buildDetailRow(
                          'Email Pelanggan:',
                          transaction.user!.email ?? '-',
                          Icons.email,
                        ),
                      ] else ...[
                        const Text('Informasi pelanggan tidak tersedia.'),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }
          // Menampilkan pesan error jika state adalah TransactionDetailError
          else if (state is TransactionDetailError) {
            print('ERROR: TransactionDetailCustomerPage: State is TransactionDetailError. Message: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          }
          // Fallback untuk state yang tidak terduga
          print('DEBUG: TransactionDetailCustomerPage: Unexpected state, returning SizedBox.shrink(). Current state: $state');
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Widget helper untuk membuat baris detail dengan label, nilai, dan ikon
  Widget _buildDetailRow(String label, String value, IconData icon, {Color? valueColor, FontWeight? valueWeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: valueColor, fontWeight: valueWeight),
            ),
          ),
        ],
      ),
    );
  }
}