import 'package:http/http.dart' as http;
import 'package:tugas_akhir/service/service_http.dart';
import 'dart:typed_data';

class LaporanRepository {
  final ServiceHttp _serviceHttp;

  LaporanRepository(this._serviceHttp);

  /// Mengunduh laporan pemasukan dan pengeluaran dalam format PDF.
  /// Mengembalikan [Uint8List] dari data PDF.
  Future<Uint8List> exportLaporanPDF() async {
    try {
      final http.Response response = await _serviceHttp.safeRequest(
        () => _serviceHttp.get('admin/laporan/export/pdf'), // Sesuaikan endpoint
      );

      // Pastikan respons adalah PDF (application/pdf)
      if (response.statusCode == 200 && response.headers['content-type'] == 'application/pdf') {
        return response.bodyBytes; // Mengembalikan byte dari file PDF
      } else {
        // Jika bukan PDF atau status code tidak 200, lempar error
        throw Exception('Gagal mengunduh laporan PDF. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error exporting laporan PDF: $e');
      rethrow; // Lempar kembali error untuk ditangani oleh BLoC
    }
  }
}