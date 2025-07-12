import 'dart:convert';

class KonfirmasiPaymentSparepartResponseModel {
    final String? message;
    final Data? data;

    KonfirmasiPaymentSparepartResponseModel({
        this.message,
        this.data,
    });

    factory KonfirmasiPaymentSparepartResponseModel.fromJson(String str) => KonfirmasiPaymentSparepartResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory KonfirmasiPaymentSparepartResponseModel.fromMap(Map<String, dynamic> json) => KonfirmasiPaymentSparepartResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? paymentId;
    final int? transactionId;
    final String? totalPembayaran;
    final String? paymentStatus;
    final String? metodePembayaran;
    final String? buktiPembayaran;
    final DateTime? paymentDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Data({
        this.paymentId,
        this.transactionId,
        this.totalPembayaran,
        this.paymentStatus,
        this.metodePembayaran,
        this.buktiPembayaran,
        this.paymentDate,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        paymentId: json["payment_id"],
        transactionId: json["transaction_id"],
        totalPembayaran: json["total_pembayaran"],
        paymentStatus: json["payment_status"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaran: json["bukti_pembayaran"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    };
}
