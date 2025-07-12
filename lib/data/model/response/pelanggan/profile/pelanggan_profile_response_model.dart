class PelangganProfileResponseModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  PelangganProfileResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  // Fungsi untuk membuat objek ProfileResponse dari JSON
  factory PelangganProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return PelangganProfileResponseModel(
      message: json['message'],
      statusCode: json['status_code'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String name;
  final String phone;
  final String address;
  final String profilePicture;

  Data({
    required this.name,
    required this.phone,
    required this.address,
    required this.profilePicture,
  });

  // Fungsi untuk membuat objek ProfileData dari JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      profilePicture: json['profile_picture'],
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'profile_picture': profilePicture,
    };
  }
}
