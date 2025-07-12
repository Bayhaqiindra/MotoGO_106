import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/data/model/request/admin/profile/admin_profile_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/profile/admin_profile_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';

class AdminProfileRepository {
  final ServiceHttp _serviceHttp;

  AdminProfileRepository(this._serviceHttp);

  /// Mendapatkan profil admin
  Future<Either<String, AdminProfileResponseModel>> getProfile() async {
    log('[DEBUG] Memulai GET profil admin');
    try {
      final response = await _serviceHttp.get('admin/profile');

      log('[DEBUG] GET Admin Profile Response: ${response.statusCode}');
      log('[DEBUG] Body: ${response.body}');

      if (response.statusCode == 200) {
        final result = AdminProfileResponseModel.fromJson(json.decode(response.body));
        log('[DEBUG] Parsed Admin Profile Data: ${result.data?.toJson()}');
        return Right(result);
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      log('[EXCEPTION] Gagal mengambil profil: $e');
      return Left('Terjadi kesalahan saat mengambil profil: ${e.toString()}');
    }
  }

  /// Menambahkan profil admin (menggunakan Multipart Request untuk file)
  Future<Either<String, AdminProfileResponseModel>> addProfile(AdminProfileRequestModel requestModel) async {
    log('[DEBUG] Memulai POST tambah profil admin');
    try {
      final fields = {
        if (requestModel.name != null) 'name': requestModel.name!,
      };

      log('[DEBUG] Fields to send: $fields');
      log('[DEBUG] File path: ${requestModel.profilePicture?.path}');

      final response = await _serviceHttp.sendMultipartRequest(
        'POST',
        'admin/profile',
        fields: fields,
        file: requestModel.profilePicture,
        fileFieldName: 'profile_picture',
      );

      log('[DEBUG] ADD Admin Profile Response Status: ${response.statusCode}');
      log('[DEBUG] Body: ${response.body}');

      if (response.statusCode == 201) {
        final result = AdminProfileResponseModel.fromJson(json.decode(response.body));
        log('[DEBUG] Parsed ADD Admin Profile: ${result.data?.toJson()}');
        return Right(result);
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      log('[EXCEPTION] Gagal menambahkan profil: $e');
      return Left('Terjadi kesalahan saat menambahkan profil: ${e.toString()}');
    }
  }

  /// Memperbarui profil admin (menggunakan Multipart Request untuk file)
  Future<Either<String, AdminProfileResponseModel>> updateProfile(AdminProfileRequestModel requestModel) async {
    log('[DEBUG] Memulai PUT update profil admin');
    try {
      final fields = {
        if (requestModel.name != null) 'name': requestModel.name!,
        '_method': 'PUT', // Laravel expects _method for PUT/PATCH on POST requests
      };

      log('[DEBUG] Fields to update: $fields');
      log('[DEBUG] File path: ${requestModel.profilePicture?.path}');

      final response = await _serviceHttp.sendMultipartRequest(
        'POST', // Metode HTTP adalah POST untuk mengirim multipart/form-data
        'admin/profile', // Endpoint untuk update
        fields: fields,
        file: requestModel.profilePicture,
        fileFieldName: 'profile_picture',
      );

      log('[DEBUG] UPDATE Admin Profile Response Status: ${response.statusCode}');
      log('[DEBUG] Body: ${response.body}');

      if (response.statusCode == 200) {
        final result = AdminProfileResponseModel.fromJson(json.decode(response.body));
        log('[DEBUG] Update Admin Profile berhasil: ${result.message}');
        log('[DEBUG] Data Profil Diperbarui: ${result.data?.toJson()}');
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
  Either<String, AdminProfileResponseModel> _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      log('[ERROR] AdminProfileRepository: Gagal: ${errorData['message']}');
      return Left(errorData['message'] ?? 'Gagal: Status ${response.statusCode}');
    } catch (_) {
      return Left('Gagal: Status ${response.statusCode}');
    }
  }
}
