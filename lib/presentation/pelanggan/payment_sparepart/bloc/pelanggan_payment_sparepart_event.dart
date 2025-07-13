part of 'pelanggan_payment_sparepart_bloc.dart';

abstract class PelangganPaymentSparepartEvent extends Equatable {
  const PelangganPaymentSparepartEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk mengirim pembayaran sparepart baru.
class SubmitPelangganPaymentSparepart extends PelangganPaymentSparepartEvent {
  final SubmitPaymentSparepartRequestModel requestModel;

  const SubmitPelangganPaymentSparepart(this.requestModel);

  @override
  List<Object> get props => [requestModel];
}

/// Event untuk memuat semua riwayat pembayaran sparepart pelanggan.
class LoadPelangganPaymentSparepartHistory extends PelangganPaymentSparepartEvent {
  const LoadPelangganPaymentSparepartHistory();

  @override
  List<Object> get props => [];
}
