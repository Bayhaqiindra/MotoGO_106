// File: lib/data/model/response/sparepart/get_sparepart_by_id_response_model.dart

import 'dart:convert'; // Import ini tetap diperlukan untuk json.decode/encode

class GetSparepartByIdResponseModel {
  final int? sparepartId;
  final String? name;
  final String? description;
  final double? price;
  final int? stockQuantity; // Sesuai dengan respons JSON, ini adalah integer
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl; // Nama field di JSON adalah "image_url"

  GetSparepartByIdResponseModel({
    this.sparepartId,
    this.name,
    this.description,
    this.price,
    this.stockQuantity,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  // Factory constructor untuk membuat instance dari String JSON
  factory GetSparepartByIdResponseModel.fromJson(String str) =>
      GetSparepartByIdResponseModel.fromMap(json.decode(str));

  // Method untuk mengubah instance menjadi String JSON
  String toJson() => json.encode(toMap());

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory GetSparepartByIdResponseModel.fromMap(Map<String, dynamic> json) =>
      GetSparepartByIdResponseModel(
        sparepartId: json["sparepart_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"] == null
            ? null
            : double.tryParse(json["price"].toString()),
        stockQuantity: json["stock_quantity"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        imageUrl: json["image_url"],
      );

  // Method untuk mengubah instance menjadi Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "sparepart_id": sparepartId,
        "name": name,
        "description": description,
        "price": price,
        "stock_quantity": stockQuantity,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "image_url": imageUrl,
      };
}