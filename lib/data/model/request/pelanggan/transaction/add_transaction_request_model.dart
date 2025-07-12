import 'dart:convert';

class AddtransactionrequestModel {
    final int? sparepartId;
    final int? quantity;

    AddtransactionrequestModel({
        this.sparepartId,
        this.quantity,
    });

    factory AddtransactionrequestModel.fromJson(String str) => AddtransactionrequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddtransactionrequestModel.fromMap(Map<String, dynamic> json) => AddtransactionrequestModel(
        sparepartId: json["sparepart_id"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toMap() => {
        "sparepart_id": sparepartId,
        "quantity": quantity,
    };
}
