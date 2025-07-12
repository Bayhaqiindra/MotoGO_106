import 'dart:convert';

class PelangganConfirmationResquestModel {
    final bool? customerAgreed;

    PelangganConfirmationResquestModel({
        this.customerAgreed,
    });

    factory PelangganConfirmationResquestModel.fromJson(String str) => PelangganConfirmationResquestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PelangganConfirmationResquestModel.fromMap(Map<String, dynamic> json) => PelangganConfirmationResquestModel(
        customerAgreed: json["customer_agreed"],
    );

    Map<String, dynamic> toMap() => {
        "customer_agreed": customerAgreed,
    };
}
