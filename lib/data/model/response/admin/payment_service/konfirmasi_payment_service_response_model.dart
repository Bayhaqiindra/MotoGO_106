import 'dart:convert';

class KonfirmasiPaymentServiceResponseodel {
    final String? message;
    final Data? data;

    KonfirmasiPaymentServiceResponseodel({
        this.message,
        this.data,
    });

    factory KonfirmasiPaymentServiceResponseodel.fromJson(String str) => KonfirmasiPaymentServiceResponseodel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory KonfirmasiPaymentServiceResponseodel.fromMap(Map<String, dynamic> json) => KonfirmasiPaymentServiceResponseodel(
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
    final int? confirmationId;
    final String? totalAmount;
    final String? paymentStatus;
    final String? metodePembayaran;
    final String? buktiPembayaran;
    final DateTime? paymentDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Data({
        this.paymentId,
        this.confirmationId,
        this.totalAmount,
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
        confirmationId: json["confirmation_id"],
        totalAmount: json["total_amount"],
        paymentStatus: json["payment_status"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaran: json["bukti_pembayaran"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "payment_id": paymentId,
        "confirmation_id": confirmationId,
        "total_amount": totalAmount,
        "payment_status": paymentStatus,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran": buktiPembayaran,
        "payment_date": paymentDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
