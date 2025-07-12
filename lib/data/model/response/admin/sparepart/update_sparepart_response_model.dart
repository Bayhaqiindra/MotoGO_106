// File: lib/data/model/response/admin/update_sparepart_response_model.dart

import 'package:equatable/equatable.dart';

class UpdateSparepartResponseModel extends Equatable {
  final String? message;
  final SparepartData? data;

  const UpdateSparepartResponseModel({
    this.message,
    this.data,
  });

  factory UpdateSparepartResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateSparepartResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : SparepartData.fromJson(json["data"]),
      );

  @override
  List<Object?> get props => [message, data];
}

class SparepartData extends Equatable {
  final int? sparepartId;
  final String? name;
  final String? description;
  final String? price;
  final String? stockQuantity;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl; // Perhatikan nama field di JSON adalah "image_url"

  const SparepartData({
    this.sparepartId,
    this.name,
    this.description,
    this.price,
    this.stockQuantity,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory SparepartData.fromJson(Map<String, dynamic> json) => SparepartData(
        sparepartId: json["sparepart_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        stockQuantity: json["stock_quantity"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        imageUrl: json["image_url"],
      );

  @override
  List<Object?> get props => [
        sparepartId,
        name,
        description,
        price,
        stockQuantity,
        createdAt,
        updatedAt,
        imageUrl,
      ];
}