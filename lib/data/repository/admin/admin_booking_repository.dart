// lib/data/repository/admin/admin_booking_repository.dart

import 'dart:convert';
import 'dart:io'; // Untuk HttpException
import 'package:tugas_akhir/data/model/request/admin/konfirmasi_service/konfirmasi_service_request_model.dart';
import 'package:tugas_akhir/data/model/request/admin/status_booking/status_booking_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/data_booking/admin_get_all_booking_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/konfirmasi_service/konfirmasi_service_response_model.dart';
// Hapus import ini jika StatusBookingDetailResponseModel tidak lagi digunakan
// import 'package:tugas_akhir/data/model/response/admin/status_booking/status_booking_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';


class AdminBookingRepository {
  final ServiceHttp _serviceHttp;

  AdminBookingRepository(this._serviceHttp);

  /// Mengambil semua booking untuk admin.
  /// Route: GET /admin/bookings
  /// Mengembalikan List<AdmingetallbookingResponseModel>
  Future<List<AdmingetallbookingResponseModel>> getAllBookings() async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('admin/bookings'),
      );

      // Mengurai respons sebagai List<dynamic> karena ini adalah array JSON
      final List<dynamic> jsonList = json.decode(response.body);

      // Memetakan setiap item JSON ke AdmingetallbookingResponseModel
      return jsonList.map((json) => AdmingetallbookingResponseModel.fromMap(json)).toList();
    } on HttpException catch (e) {
      throw Exception('Gagal mengambil semua booking: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Mengambil detail booking berdasarkan ID.
  /// Route: GET /booking/{id}
  /// Mengembalikan AdmingetallbookingResponseModel secara langsung
  Future<AdmingetallbookingResponseModel> getBookingDetail(int bookingId) async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('booking/$bookingId'), // Menggunakan shared route /booking/{id}
      );
      
      print('RAW DETAIL BOOKING API RESPONSE (${response.statusCode}): ${response.body}'); // DEBUG PENTING

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        // Karena respons langsung objek booking, tidak ada key "data"
        return AdmingetallbookingResponseModel.fromMap(jsonBody); // <-- Perubahan kunci di sini
      } else {
        // Tangani jika status code bukan 200 (misal: 404 Not Found)
        final Map<String, dynamic> errorBody = json.decode(response.body);
        final String errorMessage = errorBody['message'] ?? 'Gagal mengambil detail booking: ${response.statusCode}';
        throw HttpException(errorMessage);
      }
    } on HttpException catch (e) {
      throw Exception('Gagal mengambil detail booking: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Memperbarui status booking.
  /// Route: PUT /booking/{id}/status
  /// Menerima bookingId dan StatusBookingServiceRequestModel
  /// Mengembalikan AdmingetallbookingResponseModel (asumsi responsnya adalah booking yang diperbarui)
  Future<AdmingetallbookingResponseModel> updateBookingStatus({ // <--- Mengubah return type
    required int bookingId,
    required StatusBookingServiceRequestModel requestModel,
  }) async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.put(
          'booking/$bookingId/status', // Menggunakan route /booking/{id}/status
          body: requestModel.toMap(),
        ),
      );
      print('RAW UPDATE STATUS API RESPONSE (${response.statusCode}): ${response.body}'); // DEBUG
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return AdmingetallbookingResponseModel.fromMap(jsonBody); // <--- Perubahan di sini
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        final String errorMessage = errorBody['message'] ?? 'Gagal memperbarui status booking: ${response.statusCode}';
        throw HttpException(errorMessage);
      }
    } on HttpException catch (e) {
      throw Exception('Gagal memperbarui status booking: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Mengkonfirmasi booking dengan detail layanan dan total biaya.
  /// Route: POST /admin/confirm-service
  /// Menerima ConfirmServiceServiceRequestModel
  /// Mengembalikan ConfirmServiceServiceResponseModel
  Future<ConfirmServiceServiceResponseModel> confirmService({
    required ConfirmServiceServiceRequestModel requestModel,
  }) async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.post(
          'admin/confirm-service', // Menggunakan route /admin/confirm-service
          body: requestModel.toMap(),
        ),
      );
      // Di sini diasumsikan ConfirmServiceServiceResponseModel.fromJson sudah benar memparsing response body
      return ConfirmServiceServiceResponseModel.fromJson(response.body);
    } on HttpException catch (e) {
      throw Exception('Gagal mengkonfirmasi layanan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }
}