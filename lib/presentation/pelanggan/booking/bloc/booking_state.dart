part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingSuccess extends BookingState {
  final dynamic data;

  const BookingSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class BookingFailure extends BookingState {
  final String error;

  const BookingFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class BookingLoaded extends BookingState {
  final List<Datum> services;

  const BookingLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class CustomerBookingConfirmedSuccess extends BookingState {
  final PelangganConfirmationResponseModel confirmationResponse;
  final String message; // Bisa juga dari response.message
  const CustomerBookingConfirmedSuccess(this.confirmationResponse, this.message);

  @override
  List<Object> get props => [confirmationResponse, message];
}

class CustomerBookingsSuccess extends BookingState {
  final List<GetAllBookingResponseModel> bookings;
  const CustomerBookingsSuccess(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class CustomerBookingDetailSuccess extends BookingState {
  final GetAllBookingResponseModel booking;
  const CustomerBookingDetailSuccess(this.booking);

  @override
  List<Object> get props => [booking];
}

class AdminConfirmationDetailSuccess extends BookingState {
  final DataHistory confirmationData; // Menggunakan model Data dari PelangganConfirmationResponseModel
  const AdminConfirmationDetailSuccess(this.confirmationData);

  @override
  List<Object> get props => [confirmationData];
}