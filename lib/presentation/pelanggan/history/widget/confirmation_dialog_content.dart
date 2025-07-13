// lib/presentation/pelanggan/widgets/confirmation_dialog_content.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/confirmation_service/pelanggan_confirmation_response_model.dart'; // Untuk format mata uang

class ConfirmationDialogContent extends StatelessWidget {
  final DataHistory? confirmationData; // Menggunakan model Data dari response konfirmasi
  final String bookingStatusFromBooking; // Status booking dari GetAllBookingResponseModel
  final VoidCallback onAgree; // Callback saat pelanggan setuju
  final VoidCallback onReject; // Callback saat pelanggan menolak

  const ConfirmationDialogContent({
    Key? key,
    this.confirmationData,
    required this.bookingStatusFromBooking,
    required this.onAgree, // Wajib diisi
    required this.onReject, // Wajib diisi
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        // --- TAMBAHKAN LOG DEBUG DI SINI ---
    if (kDebugMode) {
      debugPrint('[DEBUG] ConfirmationDialogContent build called:');
      if (confirmationData == null) {
        debugPrint('  confirmationData is NULL.');
      } else {
        debugPrint('  Confirmation Data (Admin Notes) received: ${confirmationData!.adminNotes}');
        debugPrint('  Confirmation Data (Total Cost) received: ${confirmationData!.totalCost}');
        debugPrint('  Confirmation Data (Service Status) received: ${confirmationData!.serviceStatus}');
        debugPrint('  Confirmation Data (Customer Agreed) received: ${confirmationData!.customerAgreed}');
        debugPrint('  Booking Status from Booking received: $bookingStatusFromBooking');
      }
    }

    if (confirmationData == null) {
      return const Text('Memuat detail konfirmasi...');
    }

    final totalCost = confirmationData!.totalCost != null
        ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(double.tryParse(confirmationData!.totalCost!))
        : 'N/A';

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking ID: ${confirmationData!.bookingId ?? 'N/A'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text('Status Booking Anda: ${bookingStatusFromBooking.toUpperCase()}'), // Status dari booking awal
          Text('Status Layanan dari Admin: ${confirmationData!.serviceStatus?.toUpperCase() ?? 'N/A'}'), // Status yang ditetapkan admin
          Text('Total Biaya: $totalCost'),
          Text('Catatan Admin: ${confirmationData!.adminNotes ?? 'Tidak ada catatan'}'),
          const SizedBox(height: 16),
          const Text('Apakah Anda menyetujui detail dan biaya layanan ini?', style: TextStyle(fontWeight: FontWeight.w600)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton( // Gunakan OutlinedButton untuk "Tolak"
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Tolak'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton( // Gunakan ElevatedButton untuk "Setuju"
                  onPressed: onAgree,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // Warna hijau untuk setuju
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Setuju'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Lebar label
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }