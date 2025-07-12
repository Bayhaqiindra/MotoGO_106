import 'dart:convert';

class KonfirmasiPaymentSparepartRequestModel {
    final String? paymentStatus;

    KonfirmasiPaymentSparepartRequestModel({
        this.paymentStatus,
    });

    factory KonfirmasiPaymentSparepartRequestModel.fromJson(String str) => KonfirmasiPaymentSparepartRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory KonfirmasiPaymentSparepartRequestModel.fromMap(Map<String, dynamic> json) => KonfirmasiPaymentSparepartRequestModel(
        paymentStatus: json["payment_status"],
    );

    Map<String, dynamic> toMap() => {
        "payment_status": paymentStatus,
    };
}
