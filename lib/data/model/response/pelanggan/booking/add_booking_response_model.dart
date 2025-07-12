class addBookingResponseModel {
  final String message;
  final BookingData data;

  addBookingResponseModel({
    required this.message,
    required this.data,
  });

  factory addBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return addBookingResponseModel(
      message: json['message'] ?? '',
      data: BookingData.fromJson(json['data']),
    );
  }
}

class BookingData {
  final int bookingId;
  final int serviceId;
  final String pickupLocation;
  final String status;
  final String? customerNotes;
  final String latitude;
  final String longitude;
  final String? createdAt;
  final String? updatedAt;

  BookingData({
    required this.bookingId,
    required this.serviceId,
    required this.pickupLocation,
    required this.status,
    this.customerNotes,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookingId: json['booking_id'],
      serviceId: json['service_id'],
      pickupLocation: json['pickup_location'],
      status: json['status'],
      customerNotes: json['customer_notes'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
