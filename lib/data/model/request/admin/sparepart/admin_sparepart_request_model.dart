// File: lib/data/model/request/admin/create_sparepart_request_model.dart

import 'dart:io'; // Import untuk tipe File

class CreateSparepartRequestModel {
  final String name;
  final String description;
  final String price; // String karena dari form data di Postman
  final String stockQuantity; // String karena dari form data di Postman
  final File? image; // File bersifat opsional

  CreateSparepartRequestModel({
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.image,
  });

  // Method ini akan digunakan untuk mengonversi properti model
  // menjadi Map<String, String> yang dibutuhkan oleh 'fields' di sendMultipartRequest
  Map<String, String> toFormDataMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
    };
  }
}