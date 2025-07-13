// lib/presentation/admin/payment_sparepart/bloc/admin_payment_sparepart_state.dart

part of 'admin_payment_sparepart_bloc.dart';

@immutable
sealed class AdminPaymentSparepartState extends Equatable {
  const AdminPaymentSparepartState();

  @override
  List<Object> get props => [];
}

final class AdminPaymentSparepartInitial extends AdminPaymentSparepartState {}

/// State saat semua riwayat pembayaran sparepart sedang dimuat.
class AdminPaymentsSparepartLoading extends AdminPaymentSparepartState {}

/// State saat semua riwayat pembayaran sparepart berhasil dimuat.
class AdminPaymentsSparepartLoaded extends AdminPaymentSparepartState {
  final List<GetallAdminPaymentSparepartResponseModel> payments;

  const AdminPaymentsSparepartLoaded(this.payments);

  @override
  List<Object> get props => [payments];
}

/// State saat terjadi error dalam memuat semua riwayat pembayaran sparepart.
class AdminPaymentsSparepartError extends AdminPaymentSparepartState {
  final String message;

  const AdminPaymentsSparepartError(this.message);

  @override
  List<Object> get props => [message];
}

/// State saat proses konfirmasi pembayaran sparepart sedang berlangsung.
class AdminPaymentSparepartConfirmationLoading extends AdminPaymentSparepartState {}

/// State saat konfirmasi pembayaran sparepart berhasil.
class AdminPaymentSparepartConfirmationSuccess extends AdminPaymentSparepartState {
  final KonfirmasiPaymentSparepartResponseModel response;

  const AdminPaymentSparepartConfirmationSuccess(this.response);

  @override
  List<Object> get props => [response];
}

/// State saat terjadi error dalam konfirmasi pembayaran sparepart.
class AdminPaymentSparepartConfirmationError extends AdminPaymentSparepartState {
  final String message;

  const AdminPaymentSparepartConfirmationError(this.message);

  @override
  List<Object> get props => [message];
}