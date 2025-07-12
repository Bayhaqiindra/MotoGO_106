import 'dart:convert';

class GetbyidtransactionresponseModel {
    final String? message;
    final Data? data;

    GetbyidtransactionresponseModel({
        this.message,
        this.data,
    });

    factory GetbyidtransactionresponseModel.fromJson(String str) => GetbyidtransactionresponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetbyidtransactionresponseModel.fromMap(Map<String, dynamic> json) => GetbyidtransactionresponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? transactionId;
    final int? userId;
    final int? sparepartId;
    final int? quantity;
    final String? totalPrice;
    final DateTime? transactionDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? user;
    final Sparepart? sparepart;

    Data({
        this.transactionId,
        this.userId,
        this.sparepartId,
        this.quantity,
        this.totalPrice,
        this.transactionDate,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.sparepart,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        transactionId: json["transaction_id"],
        userId: json["user_id"],
        sparepartId: json["sparepart_id"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        transactionDate: json["transaction_date"] == null ? null : DateTime.parse(json["transaction_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
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
        "user": user?.toMap(),
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

class User {
    final int? userId;
    final String? email;
    final dynamic emailVerifiedAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? roleId;

    User({
        this.userId,
        this.email,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.roleId,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        roleId: json["role_id"],
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "role_id": roleId,
    };
}
