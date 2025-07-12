import 'dart:io';// Penting untuk http.MultipartFile

class SubmitPaymentSparepartRequestModel {
  final int transactionId;
  final String metodePembayaran;
  final File? buktiPembayaran;

  SubmitPaymentSparepartRequestModel({
    required this.transactionId,
    required this.metodePembayaran,
    this.buktiPembayaran, // Ini adalah parameter opsional
  });

  // Catatan: Metode toMap() ini tidak digunakan secara langsung saat mengirim
  // form-data dengan file (MultipartRequest). Data akan ditambahkan
  // secara manual ke fields dan files dari MultipartRequest.
  Map<String, dynamic> toMap() => {
        "transaction_id": transactionId,
        "metode_pembayaran": metodePembayaran,
        // 'bukti_pembayaran' tidak disertakan di sini karena ini adalah file
        // yang ditangani secara terpisah dalam http.MultipartRequest.
      };
}