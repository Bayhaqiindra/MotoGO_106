import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/booking/booking_request_model.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/confirmation_service/pelanggan_confirmation_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/booking/add_booking_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/booking/get_all_booking_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/confirmation_service/pelanggan_confirmation_response_model.dart';
import 'package:tugas_akhir/service/service_http.dart';

/// Abstraksi repository
abstract class BookingRepository {
  Future<Either<String, addBookingResponseModel>> addBooking(
    BookingRequestModel request,
  );
  Future<Either<String, List<GetAllBookingResponseModel>>> getAllBookings();
  Future<Either<String, GetAllBookingResponseModel>> getBookingById(int id);
  Future<Either<String, List<Datum>>> getAllServices();
  Future<Either<String, PelangganConfirmationResponseModel>>
  confirmBookingByPelanggan(
    int confirmationId,
    PelangganConfirmationResquestModel request,
  );
  Future<Either<String, DataHistory>> getAdminConfirmationByBookingId(
    int bookingId,
  );
}

/// Implementasi repository
class BookingRepositoryImpl implements BookingRepository {
  final ServiceHttp _http;

  BookingRepositoryImpl(this._http);

  @override
  Future<Either<String, addBookingResponseModel>> addBooking(
    BookingRequestModel request,
  ) async {
    try {
      final response = await _http.post(
        'pelanggan/booking',
        body: request.toJson(),
      );

      if (response.statusCode == 201) {
        final data = addBookingResponseModel.fromJson(
          jsonDecode(response.body),
        );
        return Right(data);
      } else {
        print('API Response Status Code: ${response.statusCode}');
        print('API Response Body: ${response.body}');
        final message =
            jsonDecode(response.body)['message'] ?? 'Gagal membuat booking';
        return Left(message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<GetAllBookingResponseModel>>>
  getAllBookings() async {
    try {
      final response = await _http.get('pelanggan/booking');

      if (response.statusCode == 200) {
        final List rawData = jsonDecode(response.body);
        final data =
            rawData.map((e) => GetAllBookingResponseModel.fromMap(e)).toList();
        return Right(data);
      } else {
        final message =
            jsonDecode(response.body)['message'] ??
            'Gagal mengambil data booking';
        return Left(message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, GetAllBookingResponseModel>> getBookingById(
    int id,
  ) async {
    try {
      // Perhatikan bahwa rute ini adalah '/booking/{id}' (shared route), bukan '/pelanggan/booking/{id}'
      final response = await _http.get('booking/$id');

      if (response.statusCode == 200) {
        final data = GetAllBookingResponseModel.fromMap(
          jsonDecode(response.body),
        );
        return Right(data);
      } else {
        final message =
            jsonDecode(response.body)['message'] ?? 'Booking tidak ditemukan';
        return Left(message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Datum>>> getAllServices() async {
    try {
      final response = await _http.get('pelanggan/services');

      // Asumsi GetAllServiceResponseModel memiliki 'statusCode' dan 'data'
      final result = GetAllServiceResponseModel.fromJson(response.body);
      if (result.statusCode == 200 && result.data != null) {
        return Right(result.data!);
      } else {
        return Left(result.message ?? 'Gagal mengambil layanan');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat mengambil layanan');
    }
  }

  @override
  Future<Either<String, PelangganConfirmationResponseModel>>
  confirmBookingByPelanggan(
    int confirmationId,
    PelangganConfirmationResquestModel request,
  ) async {
    // --- DEBUG LOG START ---
    debugPrint(
      '[DEBUG] Repository: confirmBookingByPelanggan called for bookingId: $confirmationId',
    );
    debugPrint(
      '[DEBUG] Repository: Request payload: ${request.toMap()}',
    ); // Log the request payload
    // --- DEBUG LOG END ---

    try {
      final response = await _http.put(
        'pelanggan/confirm-service/$confirmationId',
        body: request.toMap(),
      );

      // --- DEBUG LOG START ---
      debugPrint(
        '[DEBUG] Repository: Received response for confirmBookingByPelanggan PUT request.',
      );
      debugPrint(
        '[DEBUG] Repository: Response Status Code: ${response.statusCode}',
      );
      debugPrint('[DEBUG] Repository: Response Body: ${response.body}');
      // --- DEBUG LOG END ---

      if (response.statusCode == 200) {
        final data = PelangganConfirmationResponseModel.fromMap(
          jsonDecode(response.body),
        );
        // --- DEBUG LOG START ---
        debugPrint(
          '[DEBUG] Repository: Successfully parsed PelangganConfirmationResponseModel.',
        );
        // --- DEBUG LOG END ---
        return Right(data);
      } else {
        final message =
            jsonDecode(response.body)['message'] ??
            'Gagal mengkonfirmasi booking oleh pelanggan';
        // --- DEBUG LOG START ---
        debugPrint(
          '[DEBUG] Repository: Failed to confirm booking. Message: $message',
        );
        // --- DEBUG LOG END ---
        return Left(message);
      }
    } catch (e) {
      // --- DEBUG LOG START ---
      debugPrint(
        '[DEBUG] Repository: Exception caught in confirmBookingByPelanggan: $e',
      );
      // --- DEBUG LOG END ---
      return Left(e.toString());
    }
  }

  // Di BookingRepository
  @override
  Future<Either<String, DataHistory>> getAdminConfirmationByBookingId(
    int bookingId,
  ) async {
    // Menggunakan DataHistory sebagai return type langsung
    try {
      final url =
          'confirm-service/by-booking/$bookingId'; // <-- Panggil endpoint baru
      if (kDebugMode) {
        print('[DEBUG] Repository: Calling GET $url');
      }

      final response = await _http.get(url);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(
            '[DEBUG] Repository: Response status 200 for $url. Body: ${response.body}',
          );
        }
        // Langsung parsing respons ke DataHistory karena API mengembalikan objek DataHistory langsung
        final data = DataHistory.fromMap(jsonDecode(response.body));
        return Right(data);
      } else {
        final message =
            jsonDecode(response.body)['message'] ??
            'Gagal mengambil detail konfirmasi admin';
        if (kDebugMode) {
          print(
            '[DEBUG] Repository: Non-200 status code ${response.statusCode} for $url. Message: $message',
          );
        }
        return Left(message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          '[DEBUG] Repository: Exception caught in getAdminConfirmationByBookingId for bookingId $bookingId: $e',
        );
      }
      return Left(e.toString());
    }
  }
}
