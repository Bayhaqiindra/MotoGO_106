import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/payment_service/pelanggan_payment_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_service/get_all_payment_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_service/pelanggan_payment_service_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Pastikan Anda memiliki package dartz

abstract class IPelangganPaymentServiceRepository {
  Future<Either<String, PelangganPaymentServiceResponseModel>> submitPayment(
      PelangganPaymentServiceRequestModel request);
  Future<Either<String, List<GetAllPaymentServicetResponseModel>>>
      getCustomerServicePayments();
}

class PelangganPaymentServiceRepository
    implements IPelangganPaymentServiceRepository {
  final ServiceHttp _http;

  PelangganPaymentServiceRepository(this._http);

  @override
  Future<Either<String, PelangganPaymentServiceResponseModel>> submitPayment(
      PelangganPaymentServiceRequestModel request) async {
    try {
      final endpoint = 'pelanggan/payment';
      if (kDebugMode) {
        print('[DEBUG] Repository: Submitting payment to $endpoint');
        print(
            'Confirmation ID: ${request.confirmationId}, Method: ${request.metodePembayaran}');
      }

      http.Response response;

      if (request.metodePembayaran == 'transfer' &&
          request.buktiPembayaran != null) {
        // Menggunakan sendMultipartRequest untuk upload file
        response = await _http.safeRequest(() => _http.sendMultipartRequest(
              'POST',
              endpoint,
              fields: {
                'confirmation_id': request.confirmationId.toString(),
                'metode_pembayaran': request.metodePembayaran,
              },
              file: request.buktiPembayaran,
              fileFieldName: 'bukti_pembayaran', // Nama field di backend Laravel
            ));
      } else {
        // Jika bukan transfer atau tidak ada bukti (misal COD)
        response = await _http.safeRequest(() => _http.post(
              endpoint,
              body: request.toMap(), // Kirim data tanpa file
            ));
      }

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print(
              '[DEBUG] Repository: Payment submitted successfully. Body: ${response.body}');
        }
        return Right(
            PelangganPaymentServiceResponseModel.fromJson(response.body));
      } else {
        final message = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['errors'] ??
            'Gagal mengirim pembayaran';
        if (kDebugMode) {
          print(
              '[DEBUG] Repository: Submit payment failed with status ${response.statusCode}. Message: $message');
        }
        return Left(message.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print('[DEBUG] Repository: Exception submitting payment: $e');
      }
      return Left('Terjadi kesalahan: $e');
    }
  }

  @override
  Future<Either<String, List<GetAllPaymentServicetResponseModel>>>
      getCustomerServicePayments() async {
    try {
      const endpoint = 'pelanggan/payment';
      if (kDebugMode) {
        print('[DEBUG] Repository: Fetching customer service payments from $endpoint');
      }

      final response = await _http.safeRequest(() => _http.get(endpoint));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('[DEBUG] Repository: Customer payments fetched successfully. Body: ${response.body}');
        }
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<GetAllPaymentServicetResponseModel> payments = jsonList
            .map((json) => GetAllPaymentServicetResponseModel.fromMap(json))
            .toList();
        return Right(payments);
      } else {
        final message = jsonDecode(response.body)['message'] ??
            'Gagal mengambil riwayat pembayaran pelanggan';
        if (kDebugMode) {
          print(
              '[DEBUG] Repository: Fetch customer payments failed with status ${response.statusCode}. Message: $message');
        }
        return Left(message.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            '[DEBUG] Repository: Exception fetching customer payments: $e');
      }
      return Left('Terjadi kesalahan: $e');
    }
  }
}