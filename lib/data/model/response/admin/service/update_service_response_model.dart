import 'dart:convert';

class UpdateServiceResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    UpdateServiceResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory UpdateServiceResponseModel.fromJson(String str) => UpdateServiceResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UpdateServiceResponseModel.fromMap(Map<String, dynamic> json) => UpdateServiceResponseModel(
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
    final int? serviceId;
    final String? serviceName;
    final int? serviceCost;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Data({
        this.serviceId,
        this.serviceName,
        this.serviceCost,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        serviceCost: json["service_cost"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "service_id": serviceId,
        "service_name": serviceName,
        "service_cost": serviceCost,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
