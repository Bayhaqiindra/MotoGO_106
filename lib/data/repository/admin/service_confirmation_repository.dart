import 'dart:io';

import 'package:tugas_akhir/data/model/request/admin/konfirmasi_service/konfirmasi_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/konfirmasi_service/konfirmasi_service_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Sesuaikan path ini jika berbeda

class ServiceConfirmationRepository {
  final ServiceHttp _serviceHttp;

  ServiceConfirmationRepository(this._serviceHttp);

  /// Admin mengkonfirmasi booking dan mengirim pesan/catatan.
  /// Ini adalah langkah di mana admin mengatur status awal konfirmasi
  /// dan mungkin memasukkan total biaya.
  Future<ConfirmServiceServiceResponseModel> confirmService(
      ConfirmServiceServiceRequestModel requestModel) async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.post(
          'admin/confirm-service', // Route: POST /admin/confirm-service
          body: requestModel.toMap(),
        ),
      );
      return ConfirmServiceServiceResponseModel.fromJson(response.body);
    } on HttpException catch (e) {
      throw Exception('Gagal mengkonfirmasi layanan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Admin menandai konfirmasi layanan sebagai selesai (completed).
  /// Ini mungkin langkah selanjutnya setelah konfirmasi awal, jika ada flow yang lebih kompleks.
  Future<ConfirmServiceServiceResponseModel> markServiceAsCompleted(int confirmationId) async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.put(
          'admin/confirm-service/$confirmationId/complete', // Route: PUT /admin/confirm-service/{id}/complete
        ),
      );
      return ConfirmServiceServiceResponseModel.fromJson(response.body);
    } on HttpException catch (e) {
      throw Exception('Gagal menandai layanan selesai: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Mengambil detail konfirmasi layanan berdasarkan ID konfirmasi.
  /// Dapat digunakan untuk admin atau pelanggan melihat status konfirmasi tertentu.
  Future<ConfirmServiceServiceResponseModel> getServiceConfirmation(int confirmationId) async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('confirm-service/$confirmationId'), // Route: GET /confirm-service/{id}
      );
      return ConfirmServiceServiceResponseModel.fromJson(response.body);
    } on HttpException catch (e) {
      throw Exception('Gagal mengambil detail konfirmasi: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }
}