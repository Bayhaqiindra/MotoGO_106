import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import model respons Anda
import 'package:tugas_akhir/data/model/response/admin/payment_service/admin_get_all_payment_service_response_model.dart';

class AdminPaymentListTile extends StatelessWidget {
  final GetAllAdminPaymentServiceResponseodel payment;
  final VoidCallback onTapConfirm; // Callback untuk membuka dialog konfirmasi

  const AdminPaymentListTile({
    Key? key,
    required this.payment,
    required this.onTapConfirm,
  }) : super(key: key);

  // Helper untuk mendapatkan warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu': // Matches the "MENUNGGU" string in your image
        return Colors.orange;
      case 'selesai': // Matches the "SELESAI" string in your image
        return Colors.green;
      case 'ditolak': // Assuming 'ditolak' (rejected) is a possible status
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper untuk mendapatkan teks status yang sesuai
  String _getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'MENUNGGU';
      case 'confirmed':
        return 'SELESAI';
      case 'rejected':
        return 'DITOLAK';
      default:
        return status.toUpperCase(); // Fallback for unknown status
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
                // Menggunakan payment.paymentId sebagai "Transaksi ID"
                Text(
                  'Transaksi ID: ${payment.paymentId ?? '-'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // Use payment.paymentStatus for color determination
                    color: _getStatusColor(payment.paymentStatus ?? 'unknown').withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    // Use the helper to display the status in uppercase
                    _getDisplayStatus(payment.paymentStatus ?? 'N/A'),
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
            // Menggunakan payment.totalAmount dan diformat sebagai Rupiah
            Text(
              'Total Bayar: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(double.tryParse(payment.totalAmount ?? '0') ?? 0)}',
            ),
            Text(
              // Menggunakan payment.paymentDate dan diformat ke string tanggal saja
              'Tanggal Bayar: ${payment.paymentDate != null ? DateFormat('dd MMMM yyyy').format(payment.paymentDate!) : '-'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            // Tambahan detail dari model Service Payment
            // Pastikan struktur nested object sudah benar sesuai model Anda
            // Contoh: payment.serviceConfirmation?.booking?.pelanggan?.name
            Text('Nama Pelanggan: ${payment.serviceConfirmation?.booking?.pelanggan?.name ?? '-'}'),
            Text('Catatan Admin: ${payment.serviceConfirmation?.adminNotes ?? 'Tidak ada catatan'}'),

            // Tampilkan bukti pembayaran jika ada (sesuai properti buktiPembayaran)
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
                      // Implementasi untuk melihat gambar bukti pembayaran (buka di full screen dialog)
                      showDialog(
                        context: context,
                        builder: (dialogContext) => Dialog(
                          child: Image.network(
                            payment.buktiPembayaran!,
                            fit: BoxFit.contain, // Agar gambar pas di dialog
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error, size: 50, color: Colors.red));
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(
                      // Menampilkan hanya nama file dari URL
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
            // Tombol Verifikasi Pembayaran hanya muncul jika status pending/menunggu
            // Menggunakan _getDisplayStatus untuk cek status yang sesuai dengan tampilan Anda
            if (_getDisplayStatus(payment.paymentStatus ?? 'unknown') == 'MENUNGGU')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTapConfirm, // Memanggil callback onTapConfirm
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Verifikasi Pembayaran'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A60C0), // Menggunakan warna dari AppBar sparepart
                    foregroundColor: Colors.white, // Warna teks dan ikon
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