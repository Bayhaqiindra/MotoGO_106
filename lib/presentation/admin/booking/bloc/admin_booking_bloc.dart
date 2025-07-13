// lib/presentation/admin/booking/bloc/admin_booking_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas_akhir/data/model/response/admin/data_booking/admin_get_all_booking_response_model.dart'; // Pastikan ini diimpor
import 'package:tugas_akhir/data/model/request/admin/status_booking/status_booking_request_model.dart';
import 'package:tugas_akhir/data/model/request/admin/konfirmasi_service/konfirmasi_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/konfirmasi_service/konfirmasi_service_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/admin_booking_repository.dart';


part 'admin_booking_event.dart';
part 'admin_booking_state.dart';

class AdminBookingBloc extends Bloc<AdminBookingEvent, AdminBookingState> {
  final AdminBookingRepository bookingRepository;

  AdminBookingBloc({required this.bookingRepository}) : super(AdminBookingInitial()) {
    on<GetAllBookingsEvent>(_onGetAllBookings);
    on<GetBookingDetailEvent>(_onGetBookingDetail);
    on<UpdateBookingStatusEvent>(_onUpdateBookingStatus);
    on<ConfirmServiceEvent>(_onConfirmService);
    on<ResetAdminBookingStateEvent>((event, emit) => emit(AdminBookingInitial()));
  }

  Future<void> _onGetAllBookings(
    GetAllBookingsEvent event,
    Emitter<AdminBookingState> emit,
  ) async {
    emit(AdminBookingLoading());
    try {
      final List<AdmingetallbookingResponseModel> bookings = await bookingRepository.getAllBookings();
      emit(AdminAllBookingsSuccess(bookings));
    } catch (e) {
      emit(AdminBookingError('Gagal mengambil semua booking: ${e.toString()}'));
    }
  }

  Future<void> _onGetBookingDetail(
    GetBookingDetailEvent event,
    Emitter<AdminBookingState> emit,
  ) async {
    emit(AdminBookingLoading());
    try {
      // Sekarang repository langsung mengembalikan AdmingetallbookingResponseModel
      final AdmingetallbookingResponseModel bookingDetail = await bookingRepository.getBookingDetail(event.bookingId);
      emit(AdminBookingDetailSuccess(bookingDetail));
    } catch (e) {
      emit(AdminBookingError('Gagal mengambil detail booking: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBookingStatus(
    UpdateBookingStatusEvent event,
    Emitter<AdminBookingState> emit,
  ) async {
    emit(AdminBookingLoading());
    try {
      final requestModel = StatusBookingServiceRequestModel(status: event.newStatus);
      // Repository mengembalikan AdmingetallbookingResponseModel yang diperbarui
      final AdmingetallbookingResponseModel updatedBooking = await bookingRepository.updateBookingStatus(
        bookingId: event.bookingId,
        requestModel: requestModel,
      );
      emit(AdminBookingDetailSuccess(updatedBooking)); // Emit success dengan booking yang diperbarui
    } catch (e) {
      emit(AdminBookingError('Gagal memperbarui status booking: ${e.toString()}'));
    }
  }

    Future<void> _onConfirmService(
    ConfirmServiceEvent event, // Event yang sekarang membawa properti individual
    Emitter<AdminBookingState> emit,
  ) async {
    emit(AdminBookingLoading()); // Atau state loading spesifik untuk konfirmasi
    try {
      // BANGUN ConfirmServiceServiceRequestModel DARI PROPERTI EVENT
      final ConfirmServiceServiceRequestModel requestModel = ConfirmServiceServiceRequestModel(
        bookingId: event.bookingId,
        serviceId: event.serviceId,
        serviceStatus: event.serviceStatus, // Harapannya ini 'dikonfirmasi' atau sejenisnya
        totalCost: event.totalCost,
        adminNotes: event.adminNotes,
      );

      // Panggil metode confirmService dari repository Anda dengan requestModel yang sudah dibangun
      final ConfirmServiceServiceResponseModel response = await bookingRepository.confirmService(
        requestModel: requestModel,
      );

      // Anda bisa emit state sukses yang berbeda jika ada pesan spesifik dari backend,
      // atau jika Anda ingin menampilkan booking yang dikonfirmasi.
      if (response.message != null && response.message!.isNotEmpty) {
         emit(AdminBookingActionSuccess(response.message!));
      } else {
         emit(const AdminBookingActionSuccess('Layanan berhasil dikonfirmasi.'));
      }

      // Opsional: Anda mungkin ingin memuat ulang detail booking
      // setelah konfirmasi untuk memperbarui UI.
      add(GetBookingDetailEvent(bookingId: event.bookingId)); // Memuat ulang detail booking
      
    } catch (e) {
      // Emit state error jika terjadi kesalahan
      emit(AdminBookingError('Gagal mengkonfirmasi layanan: ${e.toString()}'));
    }
  }
}