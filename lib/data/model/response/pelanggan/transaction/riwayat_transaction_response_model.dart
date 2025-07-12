import 'dart:convert';

class RiwayattransactionresponseModel {
    final int? transactionId;
    final int? userId;
    final int? sparepartId;
    final int? quantity;
    final String? totalPrice;
    final DateTime? transactionDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Sparepart? sparepart;

    RiwayattransactionresponseModel({
        this.transactionId,
        this.userId,
        this.sparepartId,
        this.quantity,
        this.totalPrice,
        this.transactionDate,
        this.createdAt,
        this.updatedAt,
        this.sparepart,
    });

    factory RiwayattransactionresponseModel.fromJson(String str) => RiwayattransactionresponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RiwayattransactionresponseModel.fromMap(Map<String, dynamic> json) => RiwayattransactionresponseModel(
        transactionId: json["transaction_id"],
        userId: json["user_id"],
        sparepartId: json["sparepart_id"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        transactionDate: json["transaction_date"] == null ? null : DateTime.parse(json["transaction_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        sparepart: json["sparepart"] == null ? null : Sparepart.fromMap(json["sparepart"]),
    );

    Map<String, dynamic> toMap() => {
        "transaction_id": transactionId,
        "user_id": userId,
        "sparepart_id": sparepartId,
        "quantity": quantity,
        "total_price": totalPrice,
        "transaction_date": transactionDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "sparepart": sparepart?.toMap(),
    };
}

class Sparepart {
    final int? sparepartId;
    final String? name;
    final String? description;
    final String? price;
    final int? stockQuantity;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? imageUrl;

    Sparepart({
        this.sparepartId,
        this.name,
        this.description,
        this.price,
        this.stockQuantity,
        this.createdAt,
        this.updatedAt,
        this.imageUrl,
    });

    factory Sparepart.fromJson(String str) => Sparepart.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Sparepart.fromMap(Map<String, dynamic> json) => Sparepart(
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
