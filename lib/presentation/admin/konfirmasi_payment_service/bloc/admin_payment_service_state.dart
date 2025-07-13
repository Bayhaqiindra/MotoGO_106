part of 'admin_payment_service_bloc.dart';

// State dasar untuk Payment Service Admin
abstract class AdminPaymentServiceState extends Equatable {
  const AdminPaymentServiceState();

  @override
  List<Object?> get props => [];
}

// State awal/idle
class AdminPaymentServiceInitial extends AdminPaymentServiceState {}

// State loading
class AdminPaymentServiceLoading extends AdminPaymentServiceState {}

// State ketika semua pembayaran admin berhasil dimuat
class AllAdminServicePaymentsLoaded extends AdminPaymentServiceState {
  final List<GetAllAdminPaymentServiceResponseodel> payments;

  const AllAdminServicePaymentsLoaded({required this.payments});

  @override
  List<Object?> get props => [payments];
}

// State ketika verifikasi pembayaran berhasil
class AdminServicePaymentVerified extends AdminPaymentServiceState {
  final KonfirmasiPaymentServiceResponseodel response;

  const AdminServicePaymentVerified({required this.response});

  @override
  List<Object?> get props => [response];
}

// State ketika terjadi kegagalan
class AdminPaymentServiceFailure extends AdminPaymentServiceState {
  final String error;

  const AdminPaymentServiceFailure(this.error);

  @override
  List<Object?> get props => [error];
}