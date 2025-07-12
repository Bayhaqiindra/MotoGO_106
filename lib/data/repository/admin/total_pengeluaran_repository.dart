import 'dart:convert';
import 'package:http/http.dart' as http; // Import http package
import 'package:tugas_akhir/data/model/response/admin/total_pengeluaran/total_pengeluaran_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';

class TotalPengeluaranRepository {
  final ServiceHttp _serviceHttp;

  TotalPengeluaranRepository(this._serviceHttp);

  /// Mendapatkan total jumlah pengeluaran.
  /// GET /admin/pengeluaran/total
  Future<TotalPengeluaranResponseModel> getTotalPengeluaran() async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('admin/pengeluaran/total'),
      );
      return TotalPengeluaranResponseModel.fromJson(response.body);
    } catch (e) {
      print('Error getting total pengeluaran: $e');
      rethrow; // Melemparkan kembali exception agar dapat ditangkap di BLoC
    }
  }
}