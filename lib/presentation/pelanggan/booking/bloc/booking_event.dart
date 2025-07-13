part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class AddBookingRequested extends BookingEvent {
  final BookingRequestModel request;

  const AddBookingRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetAllBookingsRequested extends BookingEvent {
  const GetAllBookingsRequested();
}

class GetBookingDetailRequested extends BookingEvent {
  final int id;

  const GetBookingDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchServices extends BookingEvent {
  const FetchServices();
}

class SubmitBooking extends BookingEvent { // <-- Pastikan ini ada
  final BookingRequestModel request;
  const SubmitBooking(this.request);

  @override
  List<Object> get props => [request];
}

class GetCustomerBookings extends BookingEvent {}

class GetCustomerBookingDetail extends BookingEvent {
  final int bookingId;
  const GetCustomerBookingDetail({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class ConfirmCustomerBooking extends BookingEvent {
  final int confirmationId;
  final bool customerAgreed; // true jika setuju, false jika tidak setuju
  const ConfirmCustomerBooking({
    required this.confirmationId,
    required this.customerAgreed,
  });

  @override
  List<Object> get props => [confirmationId, customerAgreed];
}

class RefreshCustomerBookings extends BookingEvent {}

// --- BARU: Event untuk mendapatkan detail konfirmasi dari Admin ---
class GetAdminConfirmationDetail extends BookingEvent {
  final int bookingId;
  const GetAdminConfirmationDetail({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}