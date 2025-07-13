import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/data/model/request/pelanggan/profile/pelanggan_profile_request_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/profile/pelanggan_profile_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';

class PelangganProfileRepository {
  final ServiceHttp _serviceHttp;

  PelangganProfileRepository(this._serviceHttp);

  Future<Either<String, PelangganProfileResponseModel>>
  getPelangganProfile() async {
    log('[DEBUG] Memulai GET profil pelanggan');
    try {
      final response = await _serviceHttp.get('pelanggan/profile');

      log('[DEBUG] GET Pelanggan Profile Response: ${response.statusCode}');
      log('[DEBUG] Body: ${response.body}');

      if (response.statusCode == 200) {
        final result = PelangganProfileResponseModel.fromJson(
          json.decode(response.body),
        );
        log('[DEBUG] Parsed Profile Data: ${result.data?.toJson()}');
        return Right(result);
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      log('[EXCEPTION] Gagal mengambil profil: $e');
      return Left('Terjadi kesalahan saat mengambil profil: ${e.toString()}');
    }
  }

  Future<Either<String, PelangganProfileResponseModel>> addPelangganProfile(
    PelangganProfileRequestModel requestModel,
  ) async {
    log('[DEBUG] Memulai POST tambah profil pelanggan');
    try {
      final fields = {
        if (requestModel.name != null) 'name': requestModel.name!,
        if (requestModel.phone != null) 'phone': requestModel.phone!,
        if (requestModel.address != null) 'address': requestModel.address!,
      };

      log('[DEBUG] Fields to send: $fields');
      log('[DEBUG] File path: ${requestModel.profilePicture?.path}');

      final response = await _serviceHttp.sendMultipartRequest(
        'POST',
        'pelanggan/profile',
        fields: fields,
        file: requestModel.profilePicture,
        fileFieldName: 'profile_picture',
      );

      log('[DEBUG] ADD Profile Response: ${response.statusCode}');
      log('[DEBUG] Body: ${response.body}');

      if (response.statusCode == 201) {
        final result = PelangganProfileResponseModel.fromJson(
          json.decode(response.body),
        );
        log('[DEBUG] Parsed ADD Profile: ${result.data?.toJson()}');
        return Right(result);
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      log('[EXCEPTION] Gagal menambahkan profil: $e');
      return Left('Terjadi kesalahan saat menambahkan profil: ${e.toString()}');
    }
  }

  Future<Either<String, PelangganProfileResponseModel>> updatePelangganProfile(
    PelangganProfileRequestModel requestModel,
  ) async {
    log('[DEBUG] Memulai PUT update profil pelanggan');
    try {
      final fields = {
        if (requestModel.name != null) 'name': requestModel.name!,
        if (requestModel.phone != null) 'phone': requestModel.phone!,
        if (requestModel.address != null) 'address': requestModel.address!,
        '_method': 'PUT', // ➤ Tambahkan field ini
      };

      log('[DEBUG] Fields to update: $fields');
      log('[DEBUG] File path: ${requestModel.profilePicture?.path}');

      final response = await _serviceHttp.sendMultipartRequest(
        // ➤ Ubah metode dari 'PUT' menjadi 'POST'
        'POST', // Menggunakan POST
        'pelanggan/profile',
        fields: fields,
        file: requestModel.profilePicture,
        fileFieldName: 'profile_picture',
      );

      // ... sisa kode tetap sama
      log('[DEBUG] UPDATE Profile Response: ${response.statusCode}');
      log('[DEBUG] Body: ${response.body}');

      if (response.statusCode == 200) {
        final result = PelangganProfileResponseModel.fromJson(
          json.decode(response.body),
        );
        log('[DEBUG] Parsed UPDATED Profile: ${result.data?.toJson()}');
        return Right(result);
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      log('[EXCEPTION] Gagal memperbarui profil: $e');
      return Left('Terjadi kesalahan saat memperbarui profil: ${e.toString()}');
    }
  }

  // Helper function to handle error responses
  Either<String, PelangganProfileResponseModel> _handleErrorResponse(
    http.Response response,
  ) {
    try {
      final errorData = json.decode(response.body);
      if (response.statusCode == 422 && errorData.containsKey('errors')) {
        String validationErrors = '';
        (errorData['errors'] as Map<String, dynamic>).forEach((key, value) {
          validationErrors += '${key}: ${(value as List).join(', ')}\n';
        });
        log('[ERROR] Validation Failed: $validationErrors');
        return Left('Validasi Gagal:\n$validationErrors');
      }
      log('[ERROR] Gagal: ${errorData['message']}');
      return Left(
        errorData['message'] ?? 'Gagal: Status ${response.statusCode}',
      );
    } catch (_) {
      log(
        '[ERROR] Gagal parse error response. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return Left('Gagal: Status ${response.statusCode}');
    }
  }
}
