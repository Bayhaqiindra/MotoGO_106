import 'dart:convert';

class SubmitPaymentResponseModel {
    final String? message;
    final Data? data;

    SubmitPaymentResponseModel({
        this.message,
        this.data,
    });

    factory SubmitPaymentResponseModel.fromJson(String str) => SubmitPaymentResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SubmitPaymentResponseModel.fromMap(Map<String, dynamic> json) => SubmitPaymentResponseModel(
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
    final String? totalPembayaran;
    final String? paymentStatus;
    final String? metodePembayaran;
    final String? buktiPembayaran;
    final DateTime? paymentDate;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? paymentId;

    Data({
        this.transactionId,
        this.totalPembayaran,
        this.paymentStatus,
        this.metodePembayaran,
        this.buktiPembayaran,
        this.paymentDate,
        this.updatedAt,
        this.createdAt,
        this.paymentId,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        transactionId: json["transaction_id"],
        totalPembayaran: json["total_pembayaran"],
        paymentStatus: json["payment_status"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaran: json["bukti_pembayaran"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        paymentId: json["payment_id"],
    );

    Map<String, dynamic> toMap() => {
        "transaction_id": transactionId,
        "total_pembayaran": totalPembayaran,
        "payment_status": paymentStatus,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran": buktiPembayaran,
        "payment_date": paymentDate?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "payment_id": paymentId,
    };
}
