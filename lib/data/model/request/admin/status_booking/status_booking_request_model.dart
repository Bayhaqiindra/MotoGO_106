import 'dart:convert';

class StatusBookingServiceRequestModel {
    final String? status;

    StatusBookingServiceRequestModel({
        this.status,
    });

    factory StatusBookingServiceRequestModel.fromJson(String str) => StatusBookingServiceRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StatusBookingServiceRequestModel.fromMap(Map<String, dynamic> json) => StatusBookingServiceRequestModel(
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
    };
}
