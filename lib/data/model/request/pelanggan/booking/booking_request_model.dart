class BookingRequestModel {
  final int serviceId;
  final String pickupLocation;
  final String? customerNotes;
  final String latitude;
  final String longitude;

  BookingRequestModel({
    required this.serviceId,
    required this.pickupLocation,
    this.customerNotes,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'service_id': serviceId,
      'pickup_location': pickupLocation,
      'latitude': latitude,
      'longitude': longitude,
    };

    if (customerNotes != null && customerNotes!.isNotEmpty) {
      data['customer_notes'] = customerNotes;
    }

    return data;
  }
}
