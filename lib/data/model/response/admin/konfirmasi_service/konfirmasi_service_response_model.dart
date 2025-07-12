// lib/data/model/response/admin/booking/confirm_service_service_response_model.dart
import 'dart:convert';

class ConfirmServiceServiceResponseModel {
  final String? message;
  final ConfirmServiceData? data; // Menggunakan ConfirmServiceData

  ConfirmServiceServiceResponseModel({
    this.message,
    this.data,
  });

  factory ConfirmServiceServiceResponseModel.fromJson(String str) => ConfirmServiceServiceResponseModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory ConfirmServiceServiceResponseModel.fromMap(Map<String, dynamic> json) => ConfirmServiceServiceResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : ConfirmServiceData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
      };
}

class ConfirmServiceData { // Mengganti nama dari Data agar lebih spesifik
  final int? bookingId;
  final int? serviceId;
  final String? serviceStatus;
  final int? totalCost;
  final String? adminNotes;
  final DateTime? confirmedAt;
  final dynamic customerAgreed; // Pastikan tipe data ini sesuai (bool, int, String, dll.)
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? confirmationId;

  ConfirmServiceData({
    this.bookingId,
    this.serviceId,
    this.serviceStatus,
    this.totalCost,
    this.adminNotes,
    this.confirmedAt,
    this.customerAgreed,
    this.updatedAt,
    this.createdAt,
    this.confirmationId,
  });

  factory ConfirmServiceData.fromJson(String str) => ConfirmServiceData.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory ConfirmServiceData.fromMap(Map<String, dynamic> json) => ConfirmServiceData(
        bookingId: json["booking_id"],
        serviceId: json["service_id"],
        serviceStatus: json["service_status"],
        totalCost: json["total_cost"],
        adminNotes: json["admin_notes"],
        confirmedAt: json["confirmed_at"] == null ? null : DateTime.parse(json["confirmed_at"]),
        customerAgreed: json["customer_agreed"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        confirmationId: json["confirmation_id"],
      );

  Map<String, dynamic> toMap() => {
        "booking_id": bookingId,
        "service_id": serviceId,
        "service_status": serviceStatus,
        "total_cost": totalCost,
        "admin_notes": adminNotes,
        "confirmed_at": confirmedAt?.toIso8601String(),
        "customer_agreed": customerAgreed,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "confirmation_id": confirmationId,
      };
}