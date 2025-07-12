import 'dart:convert';

class ServiceRequestModel {
    final String? serviceName;
    final int? serviceCost;

    ServiceRequestModel({
        this.serviceName,
        this.serviceCost,
    });

    factory ServiceRequestModel.fromJson(String str) => ServiceRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ServiceRequestModel.fromMap(Map<String, dynamic> json) => ServiceRequestModel(
        serviceName: json["service_name"],
        serviceCost: json["service_cost"],
    );

    Map<String, dynamic> toMap() => {
        "service_name": serviceName,
        "service_cost": serviceCost,
    };
}
