part of 'pelanggan_payment_sparepart_bloc.dart';

abstract class PelangganPaymentSparepartState extends Equatable {
  const PelangganPaymentSparepartState();

  @override
  List<Object> get props => [];
}

/// State awal atau idle.
class PelangganPaymentSparepartInitial extends PelangganPaymentSparepartState {}

/// State saat operasi sedang berlangsung (misal: memuat data, mengirim data).
class PelangganPaymentSparepartLoading extends PelangganPaymentSparepartState {}

/// State ketika pengiriman pembayaran berhasil.
class PelangganPaymentSparepartSubmitSuccess extends PelangganPaymentSparepartState {
  final SubmitPaymentResponseModel response;

  const PelangganPaymentSparepartSubmitSuccess(this.response);

  @override
  List<Object> get props => [response];
}

/// State ketika pemuatan riwayat pembayaran berhasil.
class PelangganPaymentSparepartHistoryLoaded extends PelangganPaymentSparepartState {
  final List<GetallPaymentResponseModel> payments;

  const PelangganPaymentSparepartHistoryLoaded(this.payments);

  @override
  List<Object> get props => [payments];
}

/// State ketika terjadi kegagalan dalam operasi.
class PelangganPaymentSparepartError extends PelangganPaymentSparepartState {
  final String message;

  const PelangganPaymentSparepartError(this.message);

  @override
  List<Object> get props => [message];
}