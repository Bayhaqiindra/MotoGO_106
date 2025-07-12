import 'dart:io';

class PelangganProfileRequestModel {
  final String name;
  final String phone;
  final String address;
  final File? profilePicture;

  PelangganProfileRequestModel({
    required this.name,
    required this.phone,
    required this.address,
    this.profilePicture,
  });

  Map<String, String> toFields() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
    };
  }  // Fungsi untuk mengubah ProfileRequest menjadi format yang bisa dikirim dalam form-data


  // Fungsi untuk mengubah profile_picture menjadi file yang bisa digunakan dalam MultipartRequest
  Future<Map<String, String>> toMultipart() async {
    Map<String, String> fields = toFields();
    if (profilePicture != null) {
      // Menambahkan file profile_picture ke dalam multipart request
      fields['profile_picture'] = profilePicture!.path;
    }
    return fields;
  }
}
