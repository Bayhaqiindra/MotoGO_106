import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/response/admin/transaction/get_all_transaction_response_model.dart';
import 'package:tugas_akhir/presentation/admin/transaction/bloc/admin_transaction_bloc.dart';
import 'package:tugas_akhir/presentation/admin/transaction/widget/admin_transaction_detail_page.dart'; // Import halaman detail

class AdminAllTransactionsPage extends StatefulWidget {
  const AdminAllTransactionsPage({super.key});

  @override
  State<AdminAllTransactionsPage> createState() => _AdminAllTransactionsPageState();
}

class _AdminAllTransactionsPageState extends State<AdminAllTransactionsPage> {
  // Base URL untuk gambar (sesuaikan dengan backend Anda)
  static const String _baseUrlForImages = 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    // Memuat semua transaksi saat halaman diinisialisasi
    context.read<AdminTransactionBloc>().add(FetchAllAdminTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Transaksi Pelanggan'),
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<AdminTransactionBloc, AdminTransactionState>(
        builder: (context, state) {
          if (state is AdminTransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllAdminTransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('Belum ada transaksi yang tercatat.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                
                // Logika untuk membangun URL gambar
                String imageUrlToDisplay = '';
                if (transaction.sparepart?.imageUrl != null && transaction.sparepart!.imageUrl!.isNotEmpty) {
                  if (transaction.sparepart!.imageUrl!.startsWith('http://') || transaction.sparepart!.imageUrl!.startsWith('https://')) {
                    imageUrlToDisplay = transaction.sparepart!.imageUrl!;
                  } else {
                    imageUrlToDisplay = '$_baseUrlForImages/storage/${transaction.sparepart!.imageUrl}';
                  }
                } else {
                  imageUrlToDisplay = 'https://via.placeholder.com/60'; // Placeholder jika gambar tidak ada
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrlToDisplay,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 30, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      '${transaction.sparepart?.name ?? 'Sparepart Tidak Diketahui'}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Pelanggan: ${transaction.user?.email ?? 'N/A'}'),
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
                            builder: (context) => AdminTransactionDetailPage(
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
          } else if (state is AdminTransactionError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink(); // State awal atau tidak relevan
        },
      ),
    );
  }
}