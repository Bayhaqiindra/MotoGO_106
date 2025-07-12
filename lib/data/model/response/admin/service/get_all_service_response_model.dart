import 'dart:convert';

class GetAllServiceResponseModel {
    final String? message;
    final int? statusCode;
    final List<Datum>? data;

    GetAllServiceResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory GetAllServiceResponseModel.fromJson(String str) => GetAllServiceResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllServiceResponseModel.fromMap(Map<String, dynamic> json) => GetAllServiceResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Datum {
    final int? serviceId;
    final String? serviceName;
    final int? serviceCost;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Datum({
        this.serviceId,
        this.serviceName,
        this.serviceCost,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        // --- PERUBAHAN KRUSIAL DI SINI ---
        serviceCost: json["service_cost"] != null
            ? double.tryParse(json["service_cost"].toString())?.toInt() // Parse as double, then convert to int
            : null,
        // ---------------------------------
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
