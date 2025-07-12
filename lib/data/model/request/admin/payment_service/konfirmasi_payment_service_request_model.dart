import 'dart:convert';

class KonfirmasiPaymentServiceRequestModel {
    final String? paymentStatus;

    KonfirmasiPaymentServiceRequestModel({
        this.paymentStatus,
    });

    factory KonfirmasiPaymentServiceRequestModel.fromJson(String str) => KonfirmasiPaymentServiceRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory KonfirmasiPaymentServiceRequestModel.fromMap(Map<String, dynamic> json) => KonfirmasiPaymentServiceRequestModel(
        paymentStatus: json["payment_status"],
    );

    Map<String, dynamic> toMap() => {
        "payment_status": paymentStatus,
    };
}
