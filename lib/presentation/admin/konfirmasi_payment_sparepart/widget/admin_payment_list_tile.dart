// lib/presentation/admin/payment_sparepart/widgets/admin_payment_list_tile.dart

import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_sparepart/admin_get_all_payment_sparepart_response_model.dart';
// Asumsikan ada halaman detail transaksi jika dibutuhkan
// import 'package:tugas_akhir/presentation/pelanggan/transaction/widget/transaction_detail_customer_page.dart';

class AdminPaymentListTile extends StatelessWidget {
  final GetallAdminPaymentSparepartResponseModel payment;
  final VoidCallback onTapConfirm; // Callback untuk membuka dialog konfirmasi

  const AdminPaymentListTile({
    Key? key,
    required this.payment,
    required this.onTapConfirm,
  }) : super(key: key);

  // Helper untuk mendapatkan warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaksi ID: ${payment.transactionId ?? '-'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment.paymentStatus ?? 'unknown').withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    payment.paymentStatus?.toUpperCase() ?? 'N/A',
                    style: TextStyle(
                      color: _getStatusColor(payment.paymentStatus ?? 'unknown'),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Metode Pembayaran: ${payment.metodePembayaran ?? '-'}'),
            Text('Total Bayar: Rp ${payment.totalPembayaran ?? '0'}'),
            Text(
              'Tanggal Bayar: ${payment.paymentDate?.toLocal().toString().split(' ')[0] ?? '-'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (payment.buktiPembayaran != null && payment.buktiPembayaran!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Bukti Pembayaran:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      // Implementasi untuk melihat gambar bukti pembayaran (misal: buka di full screen)
                      // Anda bisa menggunakan PhotoView atau Navigator.push ke halaman ImageViewer
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Melihat bukti: ${payment.buktiPembayaran!.split('/').last}')),
                      );
                      // Contoh: Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(imageUrl: payment.buktiPembayaran!)));
                    },
                    child: Text(
                      payment.buktiPembayaran!.split('/').last,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Tombol Konfirmasi/Tolak hanya muncul jika status pending
            if (payment.paymentStatus?.toLowerCase() == 'pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTapConfirm,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Verifikasi Pembayaran'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Atau warna yang Anda suka
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}