import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart'; // Pastikan Anda memiliki package dartz
import 'package:tugas_akhir/data/model/request/admin/payment_service/konfirmasi_payment_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_service/admin_get_all_payment_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_service/konfirmasi_payment_service_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';

abstract class IAdminPaymentServiceRepository {
  Future<Either<String, KonfirmasiPaymentServiceResponseodel>> verifyPayment(
      int paymentId, KonfirmasiPaymentServiceRequestModel request);
  Future<Either<String, List<GetAllAdminPaymentServiceResponseodel>>>
      getAllAdminServicePayments();
}

class AdminPaymentServiceRepository
    implements IAdminPaymentServiceRepository {
  final ServiceHttp _http;

  AdminPaymentServiceRepository(this._http);

  @override
  Future<Either<String, KonfirmasiPaymentServiceResponseodel>> verifyPayment(
      int paymentId, KonfirmasiPaymentServiceRequestModel request) async {
    try {
      final endpoint = 'admin/payment/$paymentId/verify';
      if (kDebugMode) {
        print(
            '[DEBUG] Repository: Verifying payment for ID $paymentId to $endpoint');
        print('New status: ${request.paymentStatus}');
      }

      final response = await _http.safeRequest(() => _http.put(
            endpoint,
            body: request.toMap(),
          ));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(
              '[DEBUG] Repository: Payment verification successful. Body: ${response.body}');
        }
        return Right(KonfirmasiPaymentServiceResponseodel.fromJson(response.body));
      } else {
        final message = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['errors'] ??
            'Gagal memverifikasi pembayaran';
        if (kDebugMode) {
          print(
              '[DEBUG] Repository: Verify payment failed with status ${response.statusCode}. Message: $message');
        }
        return Left(message.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print('[DEBUG] Repository: Exception verifying payment: $e');
      }
      return Left('Terjadi kesalahan: $e');
    }
  }

  @override
  Future<Either<String, List<GetAllAdminPaymentServiceResponseodel>>>
      getAllAdminServicePayments() async {
    try {
      const endpoint = 'admin/payment';
      if (kDebugMode) {
        print('[DEBUG] Repository: Fetching all admin service payments from $endpoint');
      }

      final response = await _http.safeRequest(() => _http.get(endpoint));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('[DEBUG] Repository: All admin payments fetched successfully. Body: ${response.body}');
        }
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<GetAllAdminPaymentServiceResponseodel> payments = jsonList
            .map((json) => GetAllAdminPaymentServiceResponseodel.fromMap(json))
            .toList();
        return Right(payments);
      } else {
        final message = jsonDecode(response.body)['message'] ??
            'Gagal mengambil semua riwayat pembayaran admin';
        if (kDebugMode) {
          print(
              '[DEBUG] Repository: Fetch all admin payments failed with status ${response.statusCode}. Message: $message');
        }
        return Left(message.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            '[DEBUG] Repository: Exception fetching all admin payments: $e');
      }
      return Left('Terjadi kesalahan: $e');
    }
  }
}