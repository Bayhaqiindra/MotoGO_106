import 'dart:convert';
import 'dart:io'; // Import for File type

class PelangganPaymentServiceRequestModel {
  final int confirmationId;
  final String metodePembayaran;
  final File? buktiPembayaran; // Menggunakan File? karena ini adalah file upload

  PelangganPaymentServiceRequestModel({
    required this.confirmationId,
    required this.metodePembayaran,
    this.buktiPembayaran, // Buat ini opsional jika file tidak selalu diunggah
  });

  Map<String, dynamic> toMap() {
    return {
      'confirmation_id': confirmationId,
      'metode_pembayaran': metodePembayaran,
      // Untuk 'bukti_pembayaran', Anda akan menanganinya secara terpisah
      // dalam proses HTTP request (misalnya dengan FormData untuk multipart/form-data)
      // Karena Map<String, dynamic> ini lebih untuk data non-file.
    };
  }

  // Jika Anda perlu dari JSON string (jarang untuk request model, tapi disertakan jika ada kasus)
  factory PelangganPaymentServiceRequestModel.fromJson(String str) =>
      PelangganPaymentServiceRequestModel.fromMap(json.decode(str));

  // Jika Anda perlu dari Map<String, dynamic>
  factory PelangganPaymentServiceRequestModel.fromMap(Map<String, dynamic> json) =>
      PelangganPaymentServiceRequestModel(
        confirmationId: json["confirmation_id"],
        metodePembayaran: json["metode_pembayaran"],
        // buktiPembayaran tidak bisa langsung di-parse dari Map ini sebagai File
        // karena ini adalah file upload dan ditangani berbeda.
      );

  String toJson() => json.encode(toMap());
}