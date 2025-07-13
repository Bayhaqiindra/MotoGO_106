import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/presentation/admin/transaction/bloc/admin_transaction_bloc.dart';
import 'package:tugas_akhir/data/model/response/get_by_id_response_model.dart'; // Pastikan model ini diimpor

class AdminTransactionDetailPage extends StatefulWidget {
  final int transactionId;

  const AdminTransactionDetailPage({
    super.key,
    required this.transactionId,
  });

  @override
  State<AdminTransactionDetailPage> createState() => _AdminTransactionDetailPageState();
}

class _AdminTransactionDetailPageState extends State<AdminTransactionDetailPage> {
  // Base URL untuk gambar (sesuaikan dengan backend Anda)
  static const String _baseUrlForImages = 'http://10.0.2.2:8000'; // Sesuaikan ini!

  @override
  void initState() {
    super.initState();
    // Memuat detail transaksi saat halaman diinisialisasi
    context.read<AdminTransactionBloc>().add(FetchAdminTransactionDetail(
          transactionId: widget.transactionId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        backgroundColor: const Color(0xFF3A60C0),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<AdminTransactionBloc, AdminTransactionState>(
        builder: (context, state) {
          if (state is AdminTransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminTransactionDetailLoaded) {
            final transaction = state.transactionDetail.data; // Akses data dari model
            if (transaction == null) {
              return const Center(child: Text('Detail transaksi tidak ditemukan.'));
            }

            // Logika untuk membangun URL gambar
            String imageUrlToDisplay = '';
            if (transaction.sparepart?.imageUrl != null && transaction.sparepart!.imageUrl!.isNotEmpty) {
              if (transaction.sparepart!.imageUrl!.startsWith('http://') || transaction.sparepart!.imageUrl!.startsWith('https://')) {
                imageUrlToDisplay = transaction.sparepart!.imageUrl!;
              } else {
                imageUrlToDisplay = '$_baseUrlForImages/storage/${transaction.sparepart!.imageUrl}';
              }
            } else {
              imageUrlToDisplay = 'https://via.placeholder.com/150'; // Placeholder jika gambar tidak ada
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Transaksi',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          const Divider(height: 20, thickness: 1),
                          _buildDetailRow('ID Transaksi:', transaction.transactionId?.toString() ?? '-'),
                          _buildDetailRow('Tanggal Transaksi:', transaction.transactionDate?.toLocal().toString().split(' ')[0] ?? '-'),
                          // _buildDetailRow('Status:', transaction.status ?? '-'),
                          _buildDetailRow('Total Harga:', 'Rp ${double.tryParse(transaction.totalPrice ?? '0')?.toStringAsFixed(0) ?? '0'}'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Pelanggan',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          const Divider(height: 20, thickness: 1),
                          // _buildDetailRow('Nama Pelanggan:', transaction.user?.name ?? '-'),
                          _buildDetailRow('Email Pelanggan:', transaction.user?.email ?? '-'),
                          // Tambahkan detail pelanggan lain jika ada di model
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Sparepart',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          const Divider(height: 20, thickness: 1),
                          if (transaction.sparepart != null) ...[
                            Center(
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    imageUrlToDisplay,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow('Nama Sparepart:', transaction.sparepart!.name ?? '-'),
                            _buildDetailRow('Harga Satuan:', 'Rp ${double.tryParse(transaction.sparepart!.price ?? '0')?.toStringAsFixed(0) ?? '0'}'),
                            _buildDetailRow('Deskripsi:', transaction.sparepart!.description ?? '-'),
                            _buildDetailRow('Kuantitas Beli:', transaction.quantity?.toString() ?? '0'),
                          ] else ...[
                            const Text('Detail sparepart tidak tersedia.'),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AdminTransactionError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink(); // State awal atau tidak relevan
        },
      ),
    );
  }

  // Helper method untuk membangun baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Lebar label
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}