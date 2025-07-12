
import 'dart:io';

class AdminProfileRequestModel {
  final String name;
  final File? profilePicture;

  AdminProfileRequestModel({
    required this.name,
    this.profilePicture,
  });


  Map<String, String> toFields() {
    return {
      'name': name,
    };
  } 

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
