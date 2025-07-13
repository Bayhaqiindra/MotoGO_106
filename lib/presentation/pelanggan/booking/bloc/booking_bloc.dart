import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/booking/booking_request_model.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/confirmation_service/pelanggan_confirmation_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/booking/get_all_booking_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/confirmation_service/pelanggan_confirmation_response_model.dart';
import 'package:tugas_akhir/data/repository/pelanggan/booking_repository_repository.dart';

part 'booking_state.dart';
part 'booking_event.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<GetCustomerBookings>(_onGetCustomerBookings);
    on<GetCustomerBookingDetail>(_onGetCustomerBookingDetail);
    on<ConfirmCustomerBooking>(_onConfirmCustomerBooking);
    on<AddBookingRequested>(_onAddBookingRequested);
    on<GetAllBookingsRequested>(_onGetAllBookingsRequested);
    on<GetBookingDetailRequested>(_onGetBookingDetailRequested);
    on<FetchServices>(_onFetchServices);
    on<SubmitBooking>(_onSubmitBooking);
    // on<RefreshCustomerBookings>(_onRefreshCustomerBookings);
    on<GetAdminConfirmationDetail>(_onGetAdminConfirmationDetail);
  }

  Future<void> _onAddBookingRequested(
    AddBookingRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.addBooking(event.request);
    result.fold(
      (failure) => emit(BookingFailure(failure)),
      (data) => emit(BookingSuccess(data)),
    );
  }

  Future<void> _onGetAllBookingsRequested(
    GetAllBookingsRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.getAllBookings();
    result.fold(
      (failure) => emit(BookingFailure(failure)),
      (data) => emit(BookingSuccess(data)),
    );
  }

  Future<void> _onGetBookingDetailRequested(
    GetBookingDetailRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.getBookingById(event.id);
    result.fold(
      (failure) => emit(BookingFailure(failure)),
      (data) => emit(BookingSuccess(data)),
    );
  }

  Future<void> _onFetchServices(
    FetchServices event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.getAllServices();
    result.fold(
      (failure) => emit(BookingFailure(failure)),
      (services) => emit(BookingLoaded(services)),
    );
  }

  Future<void> _onSubmitBooking(
    // <-- BUAT FUNGSI HANDLER INI
    SubmitBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.addBooking(event.request);
    result.fold(
      (failure) => emit(BookingFailure(failure)),
      (data) => emit(BookingSuccess(data)),
    );
  }

  Future<void> _onGetCustomerBookings(
    GetCustomerBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await repository.getAllBookings();
    result.fold(
      (error) => emit(BookingFailure(error)),
      (bookings) => emit(CustomerBookingsSuccess(bookings)),
    );
  }

  Future<void> _onGetCustomerBookingDetail(
    GetCustomerBookingDetail event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading()); // Atau state loading spesifik untuk detail
    final result = await repository.getBookingById(event.bookingId);
    result.fold(
      (error) => emit(BookingFailure(error)), // Pastikan error message jelas
      (booking) => emit(CustomerBookingDetailSuccess(booking)),
    );
  }

  Future<void> _onConfirmCustomerBooking(
    ConfirmCustomerBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());

    // --- TAMBAHKAN LOG DEBUG DI SINI ---
    debugPrint(
      '[DEBUG] Bloc: Received ConfirmCustomerBooking event for bookingId: ${event.confirmationId}, customerAgreed: ${event.customerAgreed}',
    );
    // --- AKHIR LOG DEBUG --- // Atau state loading spesifik
    final requestModel = PelangganConfirmationResquestModel(
      customerAgreed: event.customerAgreed,
    );
    final result = await repository.confirmBookingByPelanggan(
      event.confirmationId,
      requestModel,
    );
    result.fold(
      (error) => emit(BookingFailure('Gagal konfirmasi booking: $error')),
      (response) {
        emit(
          CustomerBookingConfirmedSuccess(
            response,
            response.message ?? 'Booking berhasil dikonfirmasi!',
          ),
        );
        // Setelah berhasil konfirmasi, muat ulang detail booking atau list booking
        // Tergantung pada apa yang ingin Anda tampilkan selanjutnya.
        // add(GetCustomerBookingDetail(bookingId: event.bookingId)); // Jika ingin menampilkan detail booking yang diperbarui
        add(
          GetCustomerBookings(),
        ); // Jika ingin menampilkan daftar booking yang diperbarui
      },
    );
  }

  // Di BookingBloc Anda

  Future<void> _onGetAdminConfirmationDetail(
    GetAdminConfirmationDetail event,
    Emitter<BookingState> emit,
  ) async {
    if (kDebugMode) {
      print(
        '[DEBUG] Bloc: Received GetAdminConfirmationDetail event for bookingId: ${event.bookingId}',
      );
    }

    // Karena repository sekarang mengembalikan DataHistory langsung
    final result = await repository.getAdminConfirmationByBookingId(
      event.bookingId,
    );

    result.fold(
      (error) {
        if (kDebugMode) {
          print('[DEBUG] Bloc: Admin confirmation fetch failed: $error');
        }
        emit(BookingFailure('Gagal mengambil detail konfirmasi admin: $error'));
      },
      // 'confirmation' di sini sekarang adalah objek DataHistory secara langsung
      (confirmationData) {
        // <--- Ubah nama parameter menjadi 'confirmationData' untuk kejelasan
        if (kDebugMode) {
          // Anda tidak perlu lagi confirmationData.dataHistory
          // Cukup periksa apakah confirmationData itu sendiri tidak null jika Future mengizinkan null
          // Atau, jika DataHistory selalu ada saat sukses, Anda tidak perlu null check di sini
          print(
            '[DEBUG] Bloc: Admin confirmation fetched: Booking ID: ${confirmationData.bookingId}, Confirmation ID: ${confirmationData.confirmationId}',
          );
        }
        // Langsung kirim confirmationData ke state
        emit(
          AdminConfirmationDetailSuccess(
            confirmationData,
          ), // <--- Langsung kirim objek DataHistory
        );
      },
    );
  }
}
