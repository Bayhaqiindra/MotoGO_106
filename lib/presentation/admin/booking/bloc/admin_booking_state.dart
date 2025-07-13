part of 'admin_booking_bloc.dart'; // Penting: Jangan lupa part of

abstract class AdminBookingState extends Equatable {
  const AdminBookingState();

  @override
  List<Object> get props => [];
}

// Initial State: Ketika Bloc pertama kali dibuat
class AdminBookingInitial extends AdminBookingState {}

// Loading State: Ketika ada operasi yang sedang berjalan (misal: fetching data, updating data)
class AdminBookingLoading extends AdminBookingState {}

// Success State untuk mengambil semua booking
class AdminAllBookingsSuccess extends AdminBookingState {
  final List<AdmingetallbookingResponseModel> bookings; // List booking yang berhasil diambil
  const AdminAllBookingsSuccess(this.bookings);

  @override
  List<Object> get props => [bookings];
}

// Success State untuk mengambil detail booking atau setelah update status
class AdminBookingDetailSuccess extends AdminBookingState {
  final AdmingetallbookingResponseModel bookingDetail; // Detail booking yang berhasil diambil/diperbarui
  const AdminBookingDetailSuccess(this.bookingDetail);

  @override
  List<Object> get props => [bookingDetail];
}

// Success State untuk operasi konfirmasi layanan
class AdminServiceConfirmationSuccess extends AdminBookingState {
  final ConfirmServiceData confirmationData; // Data konfirmasi yang dikirim/dibuat
  const AdminServiceConfirmationSuccess(this.confirmationData);

  @override
  List<Object> get props => [confirmationData];
}

// Error State: Ketika terjadi kesalahan dalam operasi
class AdminBookingError extends AdminBookingState {
  final String message;
  const AdminBookingError(this.message);

  @override
  List<Object> get props => [message];
}

// State ketika sebuah operasi sukses tetapi tidak ada data yang perlu dikembalikan (opsional)
class AdminBookingActionSuccess extends AdminBookingState {
  final String message;
  const AdminBookingActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}