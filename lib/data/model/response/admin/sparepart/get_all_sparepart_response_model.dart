import 'dart:convert';

class GetallSparepartResponseModel {
    final int? sparepartId;
    final String? name;
    final String? description;
    final String? price;
    final int? stockQuantity;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? imageUrl;

    GetallSparepartResponseModel({
        this.sparepartId,
        this.name,
        this.description,
        this.price,
        this.stockQuantity,
        this.createdAt,
        this.updatedAt,
        this.imageUrl,
    });

    factory GetallSparepartResponseModel.fromJson(String str) => GetallSparepartResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetallSparepartResponseModel.fromMap(Map<String, dynamic> json) => GetallSparepartResponseModel(
        sparepartId: json["sparepart_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        stockQuantity: json["stock_quantity"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        imageUrl: json["image_url"],
    );

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
