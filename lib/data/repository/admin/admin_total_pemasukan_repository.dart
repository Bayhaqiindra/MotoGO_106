import 'package:http/http.dart' as http;
import 'package:tugas_akhir/data/model/response/admin/total_pemasukan/total_pemasukan_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart'; // Pastikan path ini benar

class TotalPemasukanRepository {
  final ServiceHttp _serviceHttp;

  // Constructor menerima instance ServiceHttp
  TotalPemasukanRepository(this._serviceHttp);

  /// Mendapatkan total pemasukan dari pembayaran sparepart dan service.
  /// Endpoint: GET /admin/pemasukan
  Future<TotalPemasukanResponseModel> getTotalPemasukan() async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('admin/pemasukan'), // Endpoint dari route Laravel Anda
      );
      // Menggunakan fromJson dari model untuk mengurai respons
      return TotalPemasukanResponseModel.fromJson(response.body);
    } catch (e) {
      // Menangani error dan melemparnya kembali untuk ditangani oleh BLoC
      print('Error getting total pemasukan: $e');
      rethrow;
    }
  }
}