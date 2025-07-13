part of 'pelanggan_payment_service_bloc.dart';

// State dasar untuk Payment Service Pelanggan
abstract class PelangganPaymentServiceState extends Equatable {
  const PelangganPaymentServiceState();

  @override
  List<Object?> get props => [];
}

// State awal/idle
class PelangganPaymentServiceInitial extends PelangganPaymentServiceState {}

// State loading
class PelangganPaymentServiceLoading extends PelangganPaymentServiceState {}

// State ketika pembayaran berhasil dikirim
class PelangganPaymentServiceSubmissionSuccess extends PelangganPaymentServiceState {
  final PelangganPaymentServiceResponseModel response;

  const PelangganPaymentServiceSubmissionSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

// State ketika terjadi kegagalan
class PelangganPaymentServiceFailure extends PelangganPaymentServiceState {
  final String error;

  const PelangganPaymentServiceFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// State ketika riwayat pembayaran pelanggan berhasil dimuat
class CustomerServicePaymentsLoaded extends PelangganPaymentServiceState {
  final List<GetAllPaymentServicetResponseModel> payments;

  const CustomerServicePaymentsLoaded({required this.payments});

  @override
  List<Object?> get props => [payments];
}