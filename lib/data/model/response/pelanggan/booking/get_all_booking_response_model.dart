import 'dart:convert';

import 'package:tugas_akhir/data/model/response/pelanggan/pelanggan_response_model.dart';

class GetAllBookingResponseModel {
    final int? bookingId;
    final int? idPelanggan;
    final int? serviceId;
    final String? status;
    final String? customerNotes;
    final String? pickupLocation;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? latitude;
    final String? longitude;
    final Pelanggan? pelanggan;

    GetAllBookingResponseModel({
        this.bookingId,
        this.idPelanggan,
        this.serviceId,
        this.status,
        this.customerNotes,
        this.pickupLocation,
        this.createdAt,
        this.updatedAt,
        this.latitude,
        this.longitude,
        this.pelanggan,
    });

    factory GetAllBookingResponseModel.fromJson(String str) => GetAllBookingResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllBookingResponseModel.fromMap(Map<String, dynamic> json) => GetAllBookingResponseModel(
        bookingId: json["booking_id"],
        idPelanggan: json["id_pelanggan"],
        serviceId: json["service_id"],
        status: json["status"],
        customerNotes: json["customer_notes"],
        pickupLocation: json["pickup_location"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        pelanggan: json["pelanggan"] == null ? null : Pelanggan.fromMap(json["pelanggan"]),
    );

    Map<String, dynamic> toMap() => {
        "booking_id": bookingId,
        "id_pelanggan": idPelanggan,
        "service_id": serviceId,
        "status": status,
        "customer_notes": customerNotes,
        "pickup_location": pickupLocation,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
        "pelanggan": pelanggan?.toMap(),
    };
}
