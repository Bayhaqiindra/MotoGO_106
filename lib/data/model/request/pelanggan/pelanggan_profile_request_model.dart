// import 'dart:convert';

// class PelangganProfileRequestModel {
//     final String? name;
//     final String? phone;
//     final String? profilePicture;
//     final String? address;

//     PelangganProfileRequestModel({
//         this.name,
//         this.phone,
//         this.profilePicture,
//         this.address,
//     });

//     factory PelangganProfileRequestModel.fromJson(String str) => PelangganProfileRequestModel.fromMap(json.decode(str));

//     String toJson() => json.encode(toMap());

//     factory PelangganProfileRequestModel.fromMap(Map<String, dynamic> json) => PelangganProfileRequestModel(
//         name: json["name"],
//         phone: json["phone"],
//         profilePicture: json["profile_picture"],
//         address: json["address"],
//     );

//     Map<String, dynamic> toMap() => {
//         "name": name,
//         "phone": phone,
//         "profile_picture": profilePicture,
//         "address": address,
//     };
// }

import 'dart:convert';
import 'dart:io'; // Import untuk tipe File

class PelangganProfileRequestModel {
  final String? name;
  final String? phone;
  final File? profilePictureFile; // Mengubah tipe data menjadi File?
  final String? address;

  PelangganProfileRequestModel({
    this.name,
    this.phone,
    this.profilePictureFile, // Sesuaikan di konstruktor
    this.address,
  });

  // Metode fromJson/toMap ini mungkin tidak akan digunakan secara langsung
  // saat mengirim multipart request, tetapi tetap dipertahankan jika ada
  // kebutuhan lain untuk serialisasi/deserialisasi model ini.
  factory PelangganProfileRequestModel.fromJson(String str) => PelangganProfileRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PelangganProfileRequestModel.fromMap(Map<String, dynamic> json) => PelangganProfileRequestModel(
    name: json["name"],
    phone: json["phone"],
    // profilePictureFile: null, // Tidak bisa membuat File dari map langsung
    address: json["address"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "phone": phone,
    // "profile_picture": profilePictureFile?.path, // Ini tidak akan mengirim file, hanya path
    "address": address,
  };
}
