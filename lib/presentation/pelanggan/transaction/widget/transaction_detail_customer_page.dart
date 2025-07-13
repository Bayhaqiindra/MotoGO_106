// lib/presentation/pelanggan/transaction/pages/transaction_detail_customer_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/bloc/transaction_bloc.dart';
import 'package:intl/intl.dart'; // Untuk formatting tanggal dan mata uang

class TransactionDetailCustomerPage extends StatefulWidget {
  final int transactionId;

  const TransactionDetailCustomerPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailCustomerPage> createState() => _TransactionDetailCustomerPageState();
}

class _TransactionDetailCustomerPageState extends State<TransactionDetailCustomerPage> {
  @override
  void initState() {
    super.initState();
    // Panggil event untuk memuat detail transaksi saat halaman dimuat
    context.read<TransactionBloc>().add(FetchTransactionDetail(transactionId: widget.transactionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionDetailLoaded) {
            final transaction = state.transactionDetail.data;
            if (transaction == null) {
              return const Center(child: Text('Data transaksi tidak ditemukan.'));
            }

            // Helper untuk format tanggal
            String formatDate(DateTime? date) {
              return date == null ? '-' : DateFormat('dd MMMM yyyy, HH:mm').format(date.toLocal());
            }

            // Helper untuk format mata uang
            String formatCurrency(String? price) {
              if (price == null) return 'Rp 0';
              try {
                final double amount = double.parse(price);
                final NumberFormat formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
                return formatter.format(amount);
              } catch (e) {
                return 'Rp $price'; // Fallback jika parsing gagal
              }
            }

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
                      _buildDetailRow(
                        'Tanggal Transaksi:',
                        formatDate(transaction.transactionDate),
                        Icons.calendar_today,
                      ),
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
                      if (transaction.sparepart != null) ...[
                        Center(
                          child: Image.network(
                            transaction.sparepart!.imageUrl ?? 'https://via.placeholder.com/150',
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow(
                          'Nama Sparepart:',
                          transaction.sparepart!.name ?? '-',
                          Icons.build,
                        ),
                        _buildDetailRow(
                          'Deskripsi:',
                          transaction.sparepart!.description ?? '-',
                          Icons.description,
                        ),
                        _buildDetailRow(
                          'Harga Satuan:',
                          formatCurrency(transaction.sparepart!.price),
                          Icons.attach_money,
                        ),
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
                      if (transaction.user != null) ...[
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
          } else if (state is TransactionDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

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