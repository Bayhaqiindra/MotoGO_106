class AdminProfileResponseModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  AdminProfileResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  // Fungsi untuk membuat objek AdminProfileResponse dari JSON
  factory AdminProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileResponseModel(
      message: json['message'],
      statusCode: json['status_code'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String name;
  final String profilePicture;

  Data({
    required this.name,
    required this.profilePicture,
  });

  // Fungsi untuk membuat objek Data dari JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json["name"],
      profilePicture: json["profile_picture"],
    );
  }

  // Fungsi untuk mengubah objek Data menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile_picture': profilePicture,
    };
  }
}
