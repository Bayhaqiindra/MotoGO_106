import 'dart:convert';

class AddServiceResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    AddServiceResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory AddServiceResponseModel.fromJson(String str) => AddServiceResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddServiceResponseModel.fromMap(Map<String, dynamic> json) => AddServiceResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toMap(),
    };
}

class Data {
    final String? serviceName;
    final int? serviceCost;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? serviceId;

    Data({
        this.serviceName,
        this.serviceCost,
        this.updatedAt,
        this.createdAt,
        this.serviceId,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        serviceName: json["service_name"],
        serviceCost: json["service_cost"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        serviceId: json["service_id"],
    );

    Map<String, dynamic> toMap() => {
        "service_name": serviceName,
        "service_cost": serviceCost,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "service_id": serviceId,
    };
}
