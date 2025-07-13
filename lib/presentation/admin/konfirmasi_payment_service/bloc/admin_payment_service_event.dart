part of 'admin_payment_service_bloc.dart';

// Event dasar untuk Payment Service Admin
abstract class AdminPaymentServiceEvent extends Equatable {
  const AdminPaymentServiceEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk memuat semua pembayaran layanan
class LoadAllAdminServicePayments extends AdminPaymentServiceEvent {
  const LoadAllAdminServicePayments();
}

// Event untuk memverifikasi pembayaran
class VerifyAdminServicePayment extends AdminPaymentServiceEvent {
  final int paymentId;
  final KonfirmasiPaymentServiceRequestModel request;

  const VerifyAdminServicePayment({
    required this.paymentId,
    required this.request,
  });

  @override
  List<Object?> get props => [paymentId, request];
}
