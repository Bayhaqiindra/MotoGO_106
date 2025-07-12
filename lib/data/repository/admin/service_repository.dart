import 'package:dartz/dartz.dart';
import 'package:tugas_akhir/data/model/request/admin/service/service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/add_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/delete_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_by_id_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/update_service_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';

class AdminServiceRepository {
  final ServiceHttp _http;

  AdminServiceRepository(this._http);

  /// Ambil semua layanan service
  Future<Either<String, List<Datum>>> getAllServices() async {
    try {
      final response = await _http.get('admin/services');
      final result = GetAllServiceResponseModel.fromJson(response.body);

      if (result.statusCode == 200) {
        return Right(result.data ?? []);
      } else {
        return Left(result.message ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      return Left('Gagal mengambil data layanan');
    }
  }

  /// Ambil service by ID
  Future<Either<String, GetByIdServiceResponseModel>> getServiceById(int id) async {
    try {
      final response = await _http.get('admin/services/$id');
      final result = GetByIdServiceResponseModel.fromJson(response.body);

      if (result.statusCode == 200 && result.data != null) {
        return Right(result);
      } else {
        return Left(result.message ?? 'Data tidak ditemukan');
      }
    } catch (e) {
      return Left('Gagal mengambil detail layanan');
    }
  }


  /// Tambah service baru
  Future<Either<String, AddServiceResponseModel>> addService(ServiceRequestModel request) async {
    try {
      final response = await _http.post(
        'admin/services',
        body: request.toMap(),
      );

      final result = AddServiceResponseModel.fromJson(response.body);

      if (result.statusCode == 201) {
        return Right(result);
      } else {
        return Left(result.message ?? 'Gagal menambahkan layanan');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menambah layanan');
    }
  }

  /// Update service
  Future<Either<String, UpdateServiceResponseModel>> updateService(int id, ServiceRequestModel request) async {
    try {
      final response = await _http.put(
        'admin/services/$id',
        body: request.toMap(),
      );

      final result = UpdateServiceResponseModel.fromJson(response.body);

      if (result.statusCode == 200) {
        return Right(result);
      } else {
        return Left(result.message ?? 'Gagal memperbarui layanan');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat update layanan');
    }
  }

  /// Hapus service
  Future<Either<String, DeleteServiceResponseModel>> deleteService(int id) async {
    try {
      final response = await _http.delete('admin/services/$id');
      final result = DeleteServiceResponseModel.fromJson(response.body);

      if (result.statusCode == 200) {
        return Right(result);
      } else {
        return Left(result.message ?? 'Gagal menghapus layanan');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menghapus layanan');
    }
  }
}
