// File: lib/data/model/request/admin/update_sparepart_request_model.dart

import 'dart:io'; // Untuk tipe File

class UpdateSparepartRequestModel {
  final String? name; // Bisa null jika tidak semua field diupdate
  final String? description;
  final String? price;
  final String? stockQuantity;
  final File? image; // Gambar bisa diupdate atau tidak

  UpdateSparepartRequestModel({
    this.name,
    this.description,
    this.price,
    this.stockQuantity,
    this.image,
  });

  // Method untuk mengonversi model menjadi Map<String, String> untuk field teks
  Map<String, String> toFormDataMap() {
    final Map<String, String> formData = {
      '_method': 'PUT', // Penting: Ini memberitahu Laravel untuk memperlakukan ini sebagai PUT
    };
    if (name != null) formData['name'] = name!;
    if (description != null) formData['description'] = description!;
    if (price != null) formData['price'] = price!;
    if (stockQuantity != null) formData['stock_quantity'] = stockQuantity!;
    return formData;
  }
}