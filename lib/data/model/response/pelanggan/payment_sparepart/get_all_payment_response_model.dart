import 'dart:convert';

class GetallPaymentResponseModel {
    final int? paymentId;
    final int? transactionId;
    final String? totalPembayaran;
    final String? paymentStatus;
    final String? metodePembayaran;
    final String? buktiPembayaran;
    final DateTime? paymentDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Transaction? transaction;

    GetallPaymentResponseModel({
        this.paymentId,
        this.transactionId,
        this.totalPembayaran,
        this.paymentStatus,
        this.metodePembayaran,
        this.buktiPembayaran,
        this.paymentDate,
        this.createdAt,
        this.updatedAt,
        this.transaction,
    });

    factory GetallPaymentResponseModel.fromJson(String str) => GetallPaymentResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetallPaymentResponseModel.fromMap(Map<String, dynamic> json) => GetallPaymentResponseModel(
        paymentId: json["payment_id"],
        transactionId: json["transaction_id"],
        totalPembayaran: json["total_pembayaran"],
        paymentStatus: json["payment_status"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaran: json["bukti_pembayaran"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        transaction: json["transaction"] == null ? null : Transaction.fromMap(json["transaction"]),
    );

    Map<String, dynamic> toMap() => {
        "payment_id": paymentId,
        "transaction_id": transactionId,
        "total_pembayaran": totalPembayaran,
        "payment_status": paymentStatus,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran": buktiPembayaran,
        "payment_date": paymentDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "transaction": transaction?.toMap(),
    };
}

class Transaction {
    final int? transactionId;
    final int? userId;
    final int? sparepartId;
    final int? quantity;
    final String? totalPrice;
    final DateTime? transactionDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Sparepart? sparepart;

    Transaction({
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

    factory Transaction.fromJson(String str) => Transaction.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
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
