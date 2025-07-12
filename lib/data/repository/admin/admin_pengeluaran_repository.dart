// lib/data/repositories/pengeluaran_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/data/model/request/admin/pengeluaran/add_pengeluaran_request_model.dart';
import 'package:tugas_akhir/data/model/request/admin/pengeluaran/update_pengeluaran_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/add_pengeluaran_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/delete_pengeluaran_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/get_all_pengeluaran_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/update_pengeluaran_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Sesuaikan path ini

class PengeluaranRepository {
  final ServiceHttp _serviceHttp;

  PengeluaranRepository(this._serviceHttp);

  /// Mengirim permintaan untuk menambahkan pengeluaran baru.
  /// Menerima [AddPengeluaranRequestModel] sebagai body permintaan.
  /// Mengembalikan [AddPengeluaranResponseModel] jika berhasil.
  /// Melempar [Exception] jika ada kegagalan.
  Future<AddPengeluaranResponseModel> addPengeluaran(AddPengeluaranRequestModel request) async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.post(
          'admin/pengeluaran',
          body: request.toMap(),
        ),
      );

      return AddPengeluaranResponseModel.fromJson(response.body);
    } catch (e) {
      print('Error adding pengeluaran: $e');
      rethrow; // Melemparkan kembali exception untuk ditangani di layer yang lebih tinggi
    }
  }

  /// Mengirim permintaan untuk memperbarui detail pengeluaran yang sudah ada.
  /// Menerima [int id] dari pengeluaran dan [UpdatePengeluaranRequestModel] sebagai body permintaan.
  /// Mengembalikan [UpdatePengeluaranResponseModel] jika berhasil.
  /// Melempar [Exception] jika ada kegagalan.
  Future<UpdatePengeluaranResponseModel> updatePengeluaran(int id, UpdatePengeluaranRequestModel request) async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.put(
          'admin/pengeluaran/$id',
          body: request.toMap(),
        ),
      );

      return UpdatePengeluaranResponseModel.fromJson(response.body);
    } catch (e) {
      print('Error updating pengeluaran with ID $id: $e');
      rethrow;
    }
  }

  /// Mengirim permintaan untuk mendapatkan semua data pengeluaran.
  /// Mengembalikan [GetAllPengeluaranResponseModel] yang berisi daftar pengeluaran jika berhasil.
  /// Melempar [Exception] jika ada kegagalan.
  Future<GetAllPengeluaranResponseModel> getAllPengeluaran() async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('admin/pengeluaran'),
      );

      return GetAllPengeluaranResponseModel.fromJson(response.body);
    } catch (e) {
      print('Error getting all pengeluaran: $e');
      rethrow;
    }
  }

  /// Mengirim permintaan untuk menghapus pengeluaran berdasarkan ID.
  /// Menerima [int id] dari pengeluaran yang akan dihapus.
  /// Mengembalikan [DeletePengeluaranResponseModel] jika berhasil.
  /// Melempar [Exception] jika ada kegagalan.
  Future<DeletePengeluaranResponseModel> deletePengeluaran(int id) async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.delete('admin/pengeluaran/$id'),
      );

      return DeletePengeluaranResponseModel.fromJson(response.body);
    } catch (e) {
      print('Error deleting pengeluaran with ID $id: $e');
      rethrow;
    }
  }

  /// Mengirim permintaan untuk mendapatkan total pengeluaran.
  /// Ini mengacu pada endpoint '/admin/pengeluaran/total' yang Anda miliki.
  /// Mengembalikan [double] yang merepresentasikan total pengeluaran.
  /// Melempar [Exception] jika ada kegagalan.
  Future<double> getTotalPengeluaran() async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('admin/pengeluaran/total'),
      );

      // Asumsi response body untuk total pengeluaran adalah JSON seperti:
      // { "message": "Total pengeluaran berhasil didapatkan", "total": 123456.78 }
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      
      // Pastikan bahwa kunci 'total' ada dan dapat di-parse sebagai double
      if (jsonResponse.containsKey('total') && jsonResponse['total'] is num) {
        return (jsonResponse['total'] as num).toDouble();
      } else {
        throw Exception('Invalid response format for total pengeluaran: ${response.body}');
      }
    } catch (e) {
      print('Error getting total pengeluaran: $e');
      rethrow;
    }
  }
}