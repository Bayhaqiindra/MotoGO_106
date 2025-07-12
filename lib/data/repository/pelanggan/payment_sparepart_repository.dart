import 'dart:convert';
import 'dart:io'; // Untuk File dan HttpException
import 'package:http/http.dart' as http; // Untuk penanganan response
import 'package:tugas_akhir/data/model/request/pelanggan/payment_sparepart/submit_payment_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_sparepart/get_all_payment_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_sparepart/submit_payment_response_model.dart';

// Import ServiceHttp Anda
import 'package:tugas_akhir/service/service_http.dart';


/// Repository untuk mengelola operasi pembayaran sparepart oleh pelanggan.
/// Menyediakan metode untuk mengirim pembayaran dan melihat riwayat pembayaran.
class PelangganPaymentSparepartRepository {
  final ServiceHttp _serviceHttp;

  PelangganPaymentSparepartRepository(this._serviceHttp);

  /// Mengirim pembayaran sparepart baru.
  /// Route: POST /pelanggan/payment-sparepart
  /// Menerima SubmitPaymentSparepartRequestModel
  /// Mengembalikan SubmitPaymentResponseModel
  Future<SubmitPaymentResponseModel> submitPaymentSparepart(SubmitPaymentSparepartRequestModel request) async {
    try {
      final Map<String, String> fields = {
        'transaction_id': request.transactionId.toString(),
        'metode_pembayaran': request.metodePembayaran,
      };

      http.Response response;

      // Logika untuk mengirim multipart request jika ada bukti pembayaran (untuk transfer)
      if (request.metodePembayaran == 'transfer' && request.buktiPembayaran != null) {
        response = await _serviceHttp.safeRequest(() => _serviceHttp.sendMultipartRequest(
              'POST',
              'pelanggan/payment-sparepart',
              fields: fields,
              file: request.buktiPembayaran,
              fileFieldName: 'bukti_pembayaran',
              includeAuth: true,
            ));
      } else {
        // Jika tidak ada bukti pembayaran (misal, metode cash), kirim sebagai POST biasa
        response = await _serviceHttp.safeRequest(() => _serviceHttp.post(
              'pelanggan/payment-sparepart',
              body: fields, // Menggunakan fields sebagai body untuk POST biasa
              includeAuth: true,
            ));
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SubmitPaymentResponseModel.fromJson(response.body);
      } else {
        String errorMessage = 'Gagal mengirim pembayaran.';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['errors'] != null) {
            errorMessage = (errorJson['errors'] as Map<String, dynamic>).values.expand((element) => element as List).join('\n');
          }
        } catch (e) {
          errorMessage = 'Gagal mengirim pembayaran: ${response.statusCode} - ${response.body}';
        }
        throw HttpException(errorMessage);
      }
    } on HttpException catch (e) {
      throw Exception('Gagal mengirim pembayaran: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat mengirim pembayaran: $e');
    }
  }

  /// Mengambil semua riwayat pembayaran sparepart untuk pelanggan yang sedang login.
  /// Route: GET /pelanggan/payment-sparepart
  /// Mengembalikan List<GetallPaymentResponseModel>
  Future<List<GetallPaymentResponseModel>> getCustomerPaymentsSparepart() async {
    try {
      final response = await _serviceHttp.safeRequest(() => _serviceHttp.get(
            'pelanggan/payment-sparepart',
            includeAuth: true,
          ));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => GetallPaymentResponseModel.fromMap(e)).toList();
      } else {
        String errorMessage = 'Gagal mengambil riwayat pembayaran pelanggan.';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['errors'] != null) {
            errorMessage = (errorJson['errors'] as Map<String, dynamic>).values.expand((element) => element as List).join('\n');
          }
        } catch (e) {
          errorMessage = 'Gagal mengambil riwayat pembayaran pelanggan: ${response.statusCode} - ${response.body}';
        }
        throw HttpException(errorMessage);
      }
    } on HttpException catch (e) {
      throw Exception('Gagal mengambil riwayat pembayaran pelanggan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat mengambil riwayat pembayaran pelanggan: $e');
    }
  }
}