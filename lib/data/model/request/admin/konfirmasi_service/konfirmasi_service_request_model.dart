import 'dart:convert';

class ConfirmServiceServiceRequestModel {
    final int? bookingId;
    final int? serviceId;
    final String? serviceStatus;
    final int? totalCost;
    final String? adminNotes;

    ConfirmServiceServiceRequestModel({
        this.bookingId,
        this.serviceId,
        this.serviceStatus,
        this.totalCost,
        this.adminNotes,
    });

    factory ConfirmServiceServiceRequestModel.fromJson(String str) => ConfirmServiceServiceRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ConfirmServiceServiceRequestModel.fromMap(Map<String, dynamic> json) => ConfirmServiceServiceRequestModel(
        bookingId: json["booking_id"],
        serviceId: json["service_id"],
        serviceStatus: json["service_status"],
        totalCost: json["total_cost"],
        adminNotes: json["admin_notes"],
    );

    Map<String, dynamic> toMap() => {
        "booking_id": bookingId,
        "service_id": serviceId,
        "service_status": serviceStatus,
        "total_cost": totalCost,
        "admin_notes": adminNotes,
    };
}
