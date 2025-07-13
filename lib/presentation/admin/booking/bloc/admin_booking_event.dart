part of 'admin_booking_bloc.dart'; // Penting: Jangan lupa part of

abstract class AdminBookingEvent extends Equatable {
  const AdminBookingEvent();

  @override
  List<Object> get props => [];
}

// Event untuk mengambil semua booking
class GetAllBookingsEvent extends AdminBookingEvent {
  const GetAllBookingsEvent();
}

// Event untuk mengambil detail booking berdasarkan ID
class GetBookingDetailEvent extends AdminBookingEvent {
  final int bookingId;
  const GetBookingDetailEvent({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

// Event untuk memperbarui status booking (diterima, ditolak, selesai, dll.)
class UpdateBookingStatusEvent extends AdminBookingEvent {
  final int bookingId;
  final String newStatus; // Misal: 'diterima', 'ditolak', 'selesai'
  const UpdateBookingStatusEvent({
    required this.bookingId,
    required this.newStatus,
  });

  @override
  List<Object> get props => [bookingId, newStatus];
}

// Event untuk mengkonfirmasi layanan dengan detail biaya dan catatan admin
class ConfirmServiceEvent extends AdminBookingEvent {
  final int bookingId;
  final int serviceId;
  final String serviceStatus; // Status layanan setelah dikonfirmasi (misal: 'dikonfirmasi')
  final int totalCost;
  final String adminNotes;

  const ConfirmServiceEvent({
    required this.bookingId,
    required this.serviceId,
    required this.serviceStatus,
    required this.totalCost,
    required this.adminNotes,
  });

  @override
  List<Object> get props => [bookingId, serviceId, serviceStatus, totalCost, adminNotes];
}

// Event untuk mereset state (opsional, berguna untuk membersihkan state setelah operasi)
class ResetAdminBookingStateEvent extends AdminBookingEvent {
  const ResetAdminBookingStateEvent();
}