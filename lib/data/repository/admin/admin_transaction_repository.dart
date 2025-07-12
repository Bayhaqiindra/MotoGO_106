// lib/data/repository/admin_transaction_repository.dart

import 'dart:convert';
import 'package:tugas_akhir/data/model/response/admin/transaction/get_all_transaction_response_model.dart';
import 'package:tugas_akhir/data/model/response/get_by_id_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Pastikan path ini benar

class AdminTransactionRepository {
  final ServiceHttp _serviceHttp;

  AdminTransactionRepository(this._serviceHttp);

  /// Mendapatkan semua transaksi (untuk admin)
  Future<List<Datum>> getAllTransactions() async {
    try {
      final response = await _serviceHttp.safeRequest(
          () => _serviceHttp.get('admin/transactions', includeAuth: true));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> dataList = responseData['data'];
          return dataList.map((json) => Datum.fromMap(json)).toList();
        } else {
          throw Exception('Format respons tidak sesuai: Data transaksi tidak ditemukan.');
        }
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            errorBody['message'] ?? 'Gagal memuat semua transaksi.');
      }
    } catch (e) {
      print('Error fetching all transactions for admin: $e');
      rethrow;
    }
  }

  /// Mendapatkan detail transaksi berdasarkan ID (untuk admin)
  /// Admin bisa melihat semua transaksi (dikelola backend)
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
      print('Error fetching transaction detail for admin: $e');
      rethrow;
    }
  }
}