// File: lib/data/repository/sparepart/sparepart_repository.dart

import 'dart:convert';
import 'dart:io'; // Diperlukan untuk File
import 'package:dartz/dartz.dart'; // Untuk Either (success/failure)
import 'package:http/http.dart' as http; // Untuk http.Response
import 'package:tugas_akhir/data/model/request/admin/sparepart/admin_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/request/admin/sparepart/update_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/add_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/delete_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_all_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_by_id_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/update_sparepart_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Model update yang saya buat sebelumnya

abstract class ISparepartRepository {
  // Methods untuk Admin (membutuhkan autentikasi admin)
  Future<Either<String, AddAdminSparepartResponseModel>> createSparepart(
      CreateSparepartRequestModel request);
  Future<Either<String, UpdateSparepartResponseModel>> updateSparepart(
      int sparepartId, UpdateSparepartRequestModel request);
  Future<Either<String, DeleteSparepartResponseModel>> deleteSparepart(
      int sparepartId);

  // Methods untuk Umum (bisa diakses admin/pelanggan setelah login)
  Future<Either<String, List<GetallSparepartResponseModel>>> getAllSpareparts();
  Future<Either<String, GetSparepartByIdResponseModel>> getSparepartById(
      int sparepartId);
}

class SparepartRepositoryImpl implements ISparepartRepository {
  final ServiceHttp _http;

  SparepartRepositoryImpl(this._http);

  /// ==============================
  /// ADMIN OPERATIONS
  /// ==============================

  @override
  Future<Either<String, AddAdminSparepartResponseModel>> createSparepart(
      CreateSparepartRequestModel request) async {
    try {
      final response = await _http.sendMultipartRequest(
        'POST', // Method POST untuk membuat sparepart baru
        'admin/spareparts', // Endpoint API untuk tambah sparepart
        fields: request.toFormDataMap(),
        file: request.image,
        fileFieldName: 'image', // Nama field untuk file di form-data
        includeAuth: true, // Asumsi ini butuh token admin
      );

      if (response.statusCode == 201) { // 201 Created jika berhasil
        final data = AddAdminSparepartResponseModel.fromJson(response.body);
        return Right(data);
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Gagal membuat sparepart';
        return Left(message);
      }
    } catch (e) {
      print('[ERROR createSparepart] $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UpdateSparepartResponseModel>> updateSparepart(
      int sparepartId, UpdateSparepartRequestModel request) async {
    try {
      final endpoint = 'admin/spareparts/$sparepartId'; // Endpoint API untuk update sparepart

      final response = await _http.sendMultipartRequest(
        'POST', // Tetap POST karena _method: PUT akan dikirim di fields
        endpoint,
        fields: request.toFormDataMap(), // Data teks termasuk _method: PUT
        file: request.image, // File gambar (opsional)
        fileFieldName: 'image', // Nama field untuk file di form-data
        includeAuth: true, // Asumsi ini butuh token admin
      );

      if (response.statusCode == 200) { // Status 200 OK untuk update berhasil
        final data = UpdateSparepartResponseModel.fromJson(jsonDecode(response.body));
        return Right(data);
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Gagal memperbarui sparepart';
        return Left(message);
      }
    } catch (e) {
      print('[ERROR updateSparepart] $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DeleteSparepartResponseModel>> deleteSparepart(
      int sparepartId) async {
    try {
      final endpoint = 'admin/spareparts/$sparepartId'; // Endpoint API untuk delete sparepart
      final response = await _http.delete(
        endpoint,
        includeAuth: true, // Asumsi ini butuh token admin
      );

      if (response.statusCode == 200) { // Status 200 OK untuk delete berhasil
        final data = DeleteSparepartResponseModel.fromJson(response.body);
        return Right(data);
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Gagal menghapus sparepart';
        return Left(message);
      }
    } catch (e) {
      print('[ERROR deleteSparepart] $e');
      return Left(e.toString());
    }
  }

  /// ==============================
  /// GENERAL (SHARED) OPERATIONS
  /// ==============================

  @override
  Future<Either<String, List<GetallSparepartResponseModel>>> getAllSpareparts() async {
    try {
      final response = await _http.get(
        'spareparts', // Endpoint API untuk semua sparepart
        includeAuth: true, // Asumsi ini butuh token (admin/pelanggan)
      );

      if (response.statusCode == 200) {
        // Asumsi respons untuk get all adalah array JSON langsung
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<GetallSparepartResponseModel> spareparts = jsonList
            .map((json) => GetallSparepartResponseModel.fromMap(json))
            .toList();
        return Right(spareparts);
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Gagal mengambil daftar sparepart';
        return Left(message);
      }
    } catch (e) {
      print('[ERROR getAllSpareparts] $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, GetSparepartByIdResponseModel>> getSparepartById(
      int sparepartId) async {
    try {
      final response = await _http.get(
        'spareparts/$sparepartId', // Endpoint API untuk sparepart by ID
        includeAuth: true, // Asumsi ini butuh token (admin/pelanggan)
      );

      if (response.statusCode == 200) { // Status 200 OK jika berhasil
        final data = GetSparepartByIdResponseModel.fromJson(response.body);
        return Right(data);
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Gagal mengambil detail sparepart';
        return Left(message);
      }
    } catch (e) {
      print('[ERROR getSparepartById] $e');
      return Left(e.toString());
    }
  }
}