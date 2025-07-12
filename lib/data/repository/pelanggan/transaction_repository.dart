// lib/data/repository/transaction_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/data/model/request/pelanggan/transaction/add_transaction_request_model.dart';
import 'package:tugas_akhir/data/model/response/get_by_id_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/transaction/add_transaction_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/transaction/riwayat_transaction_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Pastikan path ini benar

class TransactionRepository {
  final ServiceHttp _serviceHttp;

  TransactionRepository(this._serviceHttp);

  /// Menambahkan transaksi sparepart baru (untuk pelanggan)
  Future<AddtransactionresponseModel> addTransaction(
      AddtransactionrequestModel requestModel) async {
    try {
      final response = await _serviceHttp.safeRequest(() =>
          _serviceHttp.post('pelanggan/transactions',
              body: requestModel.toMap(), includeAuth: true));

      if (response.statusCode == 201) {
        return AddtransactionresponseModel.fromJson(response.body);
      } else {
        // Tangani error API (misal: stok tidak cukup, validasi gagal)
        final errorBody = json.decode(response.body);
        throw Exception(
            errorBody['message'] ?? 'Gagal menambahkan transaksi.');
      }
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  /// Mendapatkan riwayat transaksi untuk pelanggan yang sedang login
  Future<List<RiwayattransactionresponseModel>> getRiwayatTransaksi() async {
    try {
      final response = await _serviceHttp.safeRequest(
          () => _serviceHttp.get('pelanggan/transactions', includeAuth: true));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => RiwayattransactionresponseModel.fromMap(json))
            .toList();
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            errorBody['message'] ?? 'Gagal memuat riwayat transaksi.');
      }
    } catch (e) {
      print('Error fetching riwayat transaksi: $e');
      rethrow;
    }
  }

  /// Mendapatkan detail transaksi berdasarkan ID (untuk pelanggan)
  /// Pelanggan hanya bisa melihat transaksi milik sendiri (dikelola backend)
  Future<GetbyidtransactionresponseModel> getTransactionById(int transactionId) async {
    try {
      final response = await _serviceHttp.safeRequest(
          () => _serviceHttp.get('transactions/$transactionId', includeAuth: true)); // Menggunakan endpoint shared

      if (response.statusCode == 200) {
        return GetbyidtransactionresponseModel.fromJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            errorBody['message'] ?? 'Gagal memuat detail transaksi.');
      }
    } catch (e) {
      print('Error fetching transaction detail for customer: $e');
      rethrow;
    }
  }
}