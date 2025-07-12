import 'dart:convert';

class GetAllAdminPaymentServiceResponseodel {
    final int? paymentId;
    final int? confirmationId;
    final String? totalAmount;
    final String? paymentStatus;
    final String? metodePembayaran;
    final String? buktiPembayaran;
    final DateTime? paymentDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final ServiceConfirmation? serviceConfirmation;

    GetAllAdminPaymentServiceResponseodel({
        this.paymentId,
        this.confirmationId,
        this.totalAmount,
        this.paymentStatus,
        this.metodePembayaran,
        this.buktiPembayaran,
        this.paymentDate,
        this.createdAt,
        this.updatedAt,
        this.serviceConfirmation,
    });

    factory GetAllAdminPaymentServiceResponseodel.fromJson(String str) => GetAllAdminPaymentServiceResponseodel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllAdminPaymentServiceResponseodel.fromMap(Map<String, dynamic> json) => GetAllAdminPaymentServiceResponseodel(
        paymentId: json["payment_id"],
        confirmationId: json["confirmation_id"],
        totalAmount: json["total_amount"],
        paymentStatus: json["payment_status"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaran: json["bukti_pembayaran"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        serviceConfirmation: json["service_confirmation"] == null ? null : ServiceConfirmation.fromMap(json["service_confirmation"]),
    );

    Map<String, dynamic> toMap() => {
        "payment_id": paymentId,
        "confirmation_id": confirmationId,
        "total_amount": totalAmount,
        "payment_status": paymentStatus,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran": buktiPembayaran,
        "payment_date": paymentDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service_confirmation": serviceConfirmation?.toMap(),
    };
}

class ServiceConfirmation {
    final int? confirmationId;
    final int? bookingId;
    final int? serviceId;
    final String? serviceStatus;
    final String? totalCost;
    final int? customerAgreed;
    final String? adminNotes;
    final DateTime? confirmedAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Booking? booking;
    final Service? service;

    ServiceConfirmation({
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
        this.service,
    });

    factory ServiceConfirmation.fromJson(String str) => ServiceConfirmation.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ServiceConfirmation.fromMap(Map<String, dynamic> json) => ServiceConfirmation(
        confirmationId: json["confirmation_id"],
        bookingId: json["booking_id"],
        serviceId: json["service_id"],
        serviceStatus: json["service_status"],
        totalCost: json["total_cost"],
        customerAgreed: json["customer_agreed"],
        adminNotes: json["admin_notes"],
        confirmedAt: json["confirmed_at"] == null ? null : DateTime.parse(json["confirmed_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        booking: json["booking"] == null ? null : Booking.fromMap(json["booking"]),
        service: json["service"] == null ? null : Service.fromMap(json["service"]),
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
        "service": service?.toMap(),
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
    final Pelanggan? pelanggan;

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
        this.pelanggan,
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

class Pelanggan {
    final int? idPelanggan;
    final int? userId;
    final String? name;
    final String? phone;
    final String? profilePicture;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? address;

    Pelanggan({
        this.idPelanggan,
        this.userId,
        this.name,
        this.phone,
        this.profilePicture,
        this.createdAt,
        this.updatedAt,
        this.address,
    });

    factory Pelanggan.fromJson(String str) => Pelanggan.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pelanggan.fromMap(Map<String, dynamic> json) => Pelanggan(
        idPelanggan: json["id_pelanggan"],
        userId: json["user_id"],
        name: json["name"],
        phone: json["phone"],
        profilePicture: json["profile_picture"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        address: json["address"],
    );

    Map<String, dynamic> toMap() => {
        "id_pelanggan": idPelanggan,
        "user_id": userId,
        "name": name,
        "phone": phone,
        "profile_picture": profilePicture,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "address": address,
    };
}

class Service {
    final int? serviceId;
    final String? serviceName;
    final String? serviceCost;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Service({
        this.serviceId,
        this.serviceName,
        this.serviceCost,
        this.createdAt,
        this.updatedAt,
    });

    factory Service.fromJson(String str) => Service.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Service.fromMap(Map<String, dynamic> json) => Service(
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
