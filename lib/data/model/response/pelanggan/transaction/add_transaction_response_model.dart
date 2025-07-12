import 'dart:convert';

class AddtransactionresponseModel {
    final String? message;
    final Data? data;

    AddtransactionresponseModel({
        this.message,
        this.data,
    });

    factory AddtransactionresponseModel.fromJson(String str) => AddtransactionresponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddtransactionresponseModel.fromMap(Map<String, dynamic> json) => AddtransactionresponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? userId;
    final int? sparepartId;
    final int? quantity;
    final int? totalPrice;
    final DateTime? transactionDate;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? transactionId;

    Data({
        this.userId,
        this.sparepartId,
        this.quantity,
        this.totalPrice,
        this.transactionDate,
        this.updatedAt,
        this.createdAt,
        this.transactionId,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        sparepartId: json["sparepart_id"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        transactionDate: json["transaction_date"] == null ? null : DateTime.parse(json["transaction_date"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        transactionId: json["transaction_id"],
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "sparepart_id": sparepartId,
        "quantity": quantity,
        "total_price": totalPrice,
        "transaction_date": transactionDate?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "transaction_id": transactionId,
    };
}
