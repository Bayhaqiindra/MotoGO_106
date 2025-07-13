// lib/presentation/pelanggan/transaction/pages/riwayat_transaction_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<TransactionBloc>().add(FetchRiwayatTransactions());
    context.read<PelangganPaymentSparepartBloc>().add(const LoadPelangganPaymentSparepartHistory());
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
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RiwayatTransactionsLoaded) {
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
                              Text('Total: Rp ${transaction.totalPrice ?? '0'}'),
                              Text(
                                'Tanggal: ${transaction.transactionDate?.toLocal().toString().split(' ')[0] ?? '-'}',
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
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PelangganPaymentSparepartHistoryLoaded) {
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
                            'Pembayaran Transaksi ID: ${payment.transactionId}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Status: ${payment.paymentStatus ?? 'Pending'}'),
                              Text('Metode: ${payment.metodePembayaran ?? '-'}'),
                              Text('Total Bayar: Rp ${payment.totalPembayaran ?? '0'}'),
                              Text(
                                'Tanggal Bayar: ${payment.paymentDate?.toLocal().toString().split(' ')[0] ?? '-'}',
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