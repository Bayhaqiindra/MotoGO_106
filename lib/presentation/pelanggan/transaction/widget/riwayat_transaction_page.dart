// lib/presentation/pelanggan/transaction/pages/riwayat_transaction_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/presentation/pelanggan/payment_sparepart/bloc/pelanggan_payment_sparepart_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/bloc/transaction_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/transaction/widget/transaction_detail_customer_page.dart';

class RiwayatTransactionPage extends StatefulWidget {
  const RiwayatTransactionPage({super.key});

  @override
  State<RiwayatTransactionPage> createState() => _RiwayatTransactionPageState();
}

class _RiwayatTransactionPageState extends State<RiwayatTransactionPage> {
  @override
  void initState() {
    super.initState();
    // Panggil event untuk memuat riwayat transaksi saat halaman dimuat
    print('[RiwayatTransactionPage] Dispatching FetchRiwayatTransactions event...');
    context.read<TransactionBloc>().add(FetchRiwayatTransactions());
    print('[RiwayatTransactionPage] Dispatching LoadPelangganPaymentSparepartHistory event...');
    context.read<PelangganPaymentSparepartBloc>().add(const LoadPelangganPaymentSparepartHistory());
  }

  // Helper untuk format mata uang (bisa dipindahkan ke file utilitas jika sering dipakai)
  String _formatCurrency(String? price) {
    if (price == null || price.isEmpty) return 'Rp 0';
    try {
      final double amount = double.parse(price);
      final NumberFormat formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return formatter.format(amount);
    } catch (e) {
      return 'Rp $price'; // Fallback jika parsing gagal
    }
  }

  // Helper untuk format tanggal (bisa dipindahkan ke file utilitas jika sering dipakai)
  String _formatDate(DateTime? date) {
    return date == null ? '-' : DateFormat('dd MMMM yyyy, HH:mm').format(date.toLocal());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Aktivitas Saya'), // Ganti judul agar lebih umum
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Riwayat Transaksi (Pembelian Sparepart)
            Text(
              'Riwayat Pembelian Sparepart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const Divider(),
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is RiwayatTransactionsLoading) {
                  print('[RiwayatTransactionPage] TransactionBloc: Loading...');
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RiwayatTransactionsLoaded) {
                  print('[RiwayatTransactionPage] TransactionBloc: Loaded with ${state.transactions.length} items.');
                  if (state.transactions.isEmpty) {
                    return const Center(child: Text('Anda belum memiliki riwayat pembelian sparepart.'));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Agar tidak scroll sendiri
                    shrinkWrap: true, // Penting agar ListView bisa di dalam SingleChildScrollView
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = state.transactions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(Icons.shopping_cart, color: Color(0xFF3A60C0)),
                          title: Text(
                            '${transaction.sparepart?.name ?? 'Sparepart Tidak Diketahui'}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Jumlah: ${transaction.quantity ?? 0}'),
                              Text('Total: ${_formatCurrency(transaction.totalPrice)}'), // Menggunakan helper
                              Text(
                                'Tanggal: ${_formatDate(transaction.transactionDate)}', // Menggunakan helper
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            if (transaction.transactionId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailCustomerPage(
                                    transactionId: transaction.transactionId!,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                } else if (state is RiwayatTransactionsError) {
                  print('[RiwayatTransactionPage] TransactionBloc: Error - ${state.message}');
                  return Center(child: Text('Error memuat riwayat pembelian: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 32),

            // Bagian Riwayat Pembayaran (khusus status pembayaran)
            Text(
              'Riwayat Pembayaran Sparepart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const Divider(),
            BlocBuilder<PelangganPaymentSparepartBloc, PelangganPaymentSparepartState>(
              builder: (context, state) {
                if (state is PelangganPaymentSparepartLoading) {
                  print('[RiwayatTransactionPage] PelangganPaymentSparepartBloc: Loading...');
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PelangganPaymentSparepartHistoryLoaded) {
                  print('[RiwayatTransactionPage] PelangganPaymentSparepartBloc: Loaded with ${state.payments.length} items.');
                  if (state.payments.isEmpty) {
                    return const Center(child: Text('Anda belum memiliki riwayat pembayaran sparepart.'));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Agar tidak scroll sendiri
                    shrinkWrap: true, // Penting agar ListView bisa di dalam SingleChildScrollView
                    itemCount: state.payments.length,
                    itemBuilder: (context, index) {
                      final payment = state.payments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(Icons.payment, color: Color(0xFF3A60C0)),
                          title: Text(
                            'Pembayaran Transaksi ID: ${payment.transactionId ?? '-'}', // Null safety
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Status: ${payment.paymentStatus ?? 'Pending'}'),
                              Text('Metode: ${payment.metodePembayaran ?? '-'}'),
                              Text('Total Bayar: ${_formatCurrency(payment.totalPembayaran)}'), // Menggunakan helper
                              Text(
                                'Tanggal Bayar: ${_formatDate(payment.paymentDate)}', // Menggunakan helper
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              if (payment.buktiPembayaran != null && payment.buktiPembayaran!.isNotEmpty)
                                Text(
                                  'Bukti: ${payment.buktiPembayaran!.split('/').last}', // Hanya tampilkan nama file
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          ),
                          // Tidak ada onTap karena ini hanya tampilan riwayat pembayaran
                        ),
                      );
                    },
                  );
                } else if (state is PelangganPaymentSparepartError) {
                  print('[RiwayatTransactionPage] PelangganPaymentSparepartBloc: Error - ${state.message}');
                  return Center(child: Text('Error memuat riwayat pembayaran: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}