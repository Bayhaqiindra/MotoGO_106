import 'dart:convert';// Import untuk File
import 'package:dartz/dartz.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/pelanggan_profile_request_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Pastikan Anda sudah menambahkan package dartz// Sesuaikan path jika perlu

class PelangganProfileRepository {
  final ServiceHttp _serviceHttp;

  PelangganProfileRepository(this._serviceHttp);

  /// Mengambil data profil pelanggan.
  /// Mengembalikan Right(PelangganProfileResponseModel) jika berhasil, Left(String error) jika gagal.
  Future<Either<String, PelangganProfileResponseModel>> getPelangganProfile() async {
    try {
      final response = await _serviceHttp.get('pelanggan/profile'); // Sesuai dengan getProfilePelanggan di backend
      
      if (response.statusCode == 200) {
        return Right(PelangganProfileResponseModel.fromJson(response.body));
      } else {
        // Coba parsing pesan error dari backend
        final errorData = json.decode(response.body);
        return Left(errorData['message'] ?? 'Gagal memuat profil: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mengambil profil: ${e.toString()}');
    }
  }

  /// Menambahkan profil pelanggan baru.
  /// Mengambil PelangganProfileRequestModel sebagai input.
  /// Mengembalikan Right(PelangganProfileResponseModel) jika berhasil, Left(String error) jika gagal.
  Future<Either<String, PelangganProfileResponseModel>> addPelangganProfile(PelangganProfileRequestModel requestModel) async {
    try {
      // Siapkan data non-file untuk permintaan multipart
      final Map<String, String> fields = {
        if (requestModel.name != null) 'name': requestModel.name!,
        if (requestModel.phone != null) 'phone': requestModel.phone!,
        if (requestModel.address != null) 'address': requestModel.address!,
      };

      final response = await _serviceHttp.sendMultipartRequest(
        'POST', // Backend Anda menggunakan POST untuk AddProfilePelanggan
        'pelanggan/profile', // Endpoint yang diasumsikan untuk menambahkan profil
        fields: fields,
        file: requestModel.profilePictureFile, // File gambar
        fileFieldName: 'profile_picture', // Nama field yang diharapkan backend
      );

      if (response.statusCode == 201) { // Backend mengembalikan 201 untuk sukses
        return Right(PelangganProfileResponseModel.fromJson(response.body));
      } else {
        final errorData = json.decode(response.body);
        return Left(errorData['message'] ?? 'Gagal menambahkan profil: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menambahkan profil: ${e.toString()}');
    }
  }

  /// Memperbarui data profil pelanggan.
  /// Mengambil PelangganProfileRequestModel sebagai input.
  /// Mengembalikan Right(PelangganProfileResponseModel) jika berhasil, Left(String error) jika gagal.
  Future<Either<String, PelangganProfileResponseModel>> updatePelangganProfile(PelangganProfileRequestModel requestModel) async {
    try {
      // Siapkan data non-file untuk permintaan multipart
      final Map<String, String> fields = {
        if (requestModel.name != null) 'name': requestModel.name!,
        if (requestModel.phone != null) 'phone': requestModel.phone!,
        if (requestModel.address != null) 'address': requestModel.address!,
        // Jika profilePictureFile null, backend akan mempertahankan gambar lama
      };

      final response = await _serviceHttp.sendMultipartRequest(
        'POST', // Untuk multipart request, seringkali menggunakan POST, bahkan untuk update
        'pelanggan/profile/update', // Endpoint yang diasumsikan untuk memperbarui profil
        fields: fields,
        file: requestModel.profilePictureFile, // File gambar baru (jika ada)
        fileFieldName: 'profile_picture', // Nama field yang diharapkan backend
      );

      if (response.statusCode == 200) { // Backend mengembalikan 200 untuk sukses
        return Right(PelangganProfileResponseModel.fromJson(response.body));
      } else {
        final errorData = json.decode(response.body);
        return Left(errorData['message'] ?? 'Gagal memperbarui profil: Status ${response.statusCode}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat memperbarui profil: ${e.toString()}');
    }
  }
}