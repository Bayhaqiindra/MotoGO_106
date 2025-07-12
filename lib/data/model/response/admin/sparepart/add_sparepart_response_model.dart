import 'dart:convert';

class AddAdminSparepartResponseModel {
    final String? message;
    final Data? data;

    AddAdminSparepartResponseModel({
        this.message,
        this.data,
    });

    factory AddAdminSparepartResponseModel.fromJson(String str) => AddAdminSparepartResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddAdminSparepartResponseModel.fromMap(Map<String, dynamic> json) => AddAdminSparepartResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final String? name;
    final String? description;
    final String? price;
    final String? stockQuantity;
    final String? imageUrl;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? sparepartId;

    Data({
        this.name,
        this.description,
        this.price,
        this.stockQuantity,
        this.imageUrl,
        this.updatedAt,
        this.createdAt,
        this.sparepartId,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        name: json["name"],
        description: json["description"],
        price: json["price"],
        stockQuantity: json["stock_quantity"],
        imageUrl: json["image_url"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        sparepartId: json["sparepart_id"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "price": price,
        "stock_quantity": stockQuantity,
        "image_url": imageUrl,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "sparepart_id": sparepartId,
    };
}
