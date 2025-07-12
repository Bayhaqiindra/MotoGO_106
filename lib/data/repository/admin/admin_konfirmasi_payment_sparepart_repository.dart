import 'dart:convert';
import 'dart:io'; // Untuk HttpException
import 'package:tugas_akhir/data/model/request/admin/payment_sparepart/konfirmasi_payment_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_sparepart/admin_get_all_payment_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_sparepart/konfirmasi_payment_sparepart_response_model.dart';

// Import ServiceHttp Anda
import 'package:tugas_akhir/service/service_http.dart';


/// Repository untuk mengelola operasi pembayaran sparepart oleh admin.
/// Menyediakan metode untuk memverifikasi pembayaran dan melihat semua pembayaran.
class AdminPaymentSparepartRepository {
  final ServiceHttp _serviceHttp;

  AdminPaymentSparepartRepository(this._serviceHttp);

  /// Memverifikasi status pembayaran sparepart oleh admin.
  /// Route: PUT /admin/payment-sparepart/{id}/verify
  /// Menerima paymentId dan KonfirmasiPaymentSparepartRequestModel
  /// Mengembalikan KonfirmasiPaymentSparepartResponseModel
  Future<KonfirmasiPaymentSparepartResponseModel> verifyPaymentSparepart({
    required int paymentId,
    required KonfirmasiPaymentSparepartRequestModel requestModel,
  }) async {
    try {
      final response = await _serviceHttp.safeRequest(
        () => _serviceHttp.put(
          'admin/payment-sparepart/$paymentId/verify',
          body: requestModel.toMap(),
          includeAuth: true,
        ),
      );

      if (response.statusCode == 200) {
        return KonfirmasiPaymentSparepartResponseModel.fromJson(response.body);
      } else {
        String errorMessage = 'Gagal memverifikasi pembayaran sparepart.';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['errors'] != null) {
            errorMessage = (errorJson['errors'] as Map<String, dynamic>).values.expand((element) => element as List).join('\n');
          }
        } catch (e) {
          errorMessage = 'Gagal memverifikasi pembayaran sparepart: ${response.statusCode} - ${response.body}';
        }
        throw HttpException(errorMessage);
      }
    } on HttpException catch (e) {
      throw Exception('Gagal memverifikasi pembayaran sparepart: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat memverifikasi pembayaran sparepart: $e');
    }
  }

  /// Mengambil semua riwayat pembayaran sparepart untuk admin.
  /// Route: GET /admin/payment-sparepart
  /// Mengembalikan List<GetallAdminPaymentSparepartResponseModel>
  Future<List<GetallAdminPaymentSparepartResponseModel>> getAllAdminPaymentsSparepart() async {
    try {
      final response = await _serviceHttp.safeRequest(() => _serviceHttp.get(
            'admin/payment-sparepart',
            includeAuth: true,
          ));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => GetallAdminPaymentSparepartResponseModel.fromMap(e)).toList();
      } else {
        String errorMessage = 'Gagal mengambil semua riwayat pembayaran sparepart admin.';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['errors'] != null) {
            errorMessage = (errorJson['errors'] as Map<String, dynamic>).values.expand((element) => element as List).join('\n');
          }
        } catch (e) {
          errorMessage = 'Gagal mengambil semua riwayat pembayaran sparepart admin: ${response.statusCode} - ${response.body}';
        }
        throw HttpException(errorMessage);
      }
    } on HttpException catch (e) {
      throw Exception('Gagal mengambil semua riwayat pembayaran sparepart admin: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat mengambil semua riwayat pembayaran sparepart admin: $e');
    }
  }
}