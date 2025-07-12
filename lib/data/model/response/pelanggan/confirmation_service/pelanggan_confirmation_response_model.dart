import 'dart:convert';

class PelangganConfirmationResponseModel {
    final String? message;
    final DataHistory? dataHistory;

    PelangganConfirmationResponseModel({
        this.message,
        this.dataHistory,
    });

    factory PelangganConfirmationResponseModel.fromJson(String str) => PelangganConfirmationResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

factory PelangganConfirmationResponseModel.fromMap(Map<String, dynamic> json) {
        // Langsung parsing JSON root ke DataHistory
        return PelangganConfirmationResponseModel(
            dataHistory: DataHistory.fromMap(json), // Langsung parse seluruh JSON
        );
    }

Map<String, dynamic> toMap() => {
        // Ini mungkin tidak relevan jika model ini hanya untuk parsing respons
        "data_history": dataHistory?.toMap(),
    };
}

class DataHistory {
    final int? confirmationId;
    final int? bookingId;
    final int? serviceId;
    final String? serviceStatus;
    final String? totalCost;
    final bool? customerAgreed;
    final String? adminNotes;
    final DateTime? confirmedAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Booking? booking;

    DataHistory({
        this.confirmationId,
        this.bookingId,
        this.serviceId,
        this.serviceStatus,
        this.totalCost,
        this.customerAgreed,
        this.adminNotes,
        this.confirmedAt,
        this.createdAt,
        this.updatedAt,
        this.booking,
    });

    factory DataHistory.fromJson(String str) => DataHistory.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataHistory.fromMap(Map<String, dynamic> json) => DataHistory(
        confirmationId: json["confirmation_id"],
        bookingId: json["booking_id"],
        serviceId: json["service_id"],
        serviceStatus: json["service_status"],
        totalCost: json["total_cost"],
        customerAgreed: json["customer_agreed"] == null ? null : (json["customer_agreed"] == 1),
        adminNotes: json["admin_notes"],
        confirmedAt: json["confirmed_at"] == null ? null : DateTime.parse(json["confirmed_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        booking: json["booking"] == null ? null : Booking.fromMap(json["booking"]),
    );

    Map<String, dynamic> toMap() => {
        "confirmation_id": confirmationId,
        "booking_id": bookingId,
        "service_id": serviceId,
        "service_status": serviceStatus,
        "total_cost": totalCost,
        "customer_agreed": customerAgreed,
        "admin_notes": adminNotes,
        "confirmed_at": confirmedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "booking": booking?.toMap(),
    };
}

class Booking {
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

    Booking({
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
    });

    factory Booking.fromJson(String str) => Booking.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Booking.fromMap(Map<String, dynamic> json) => Booking(
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
    };
}
