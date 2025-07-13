part of 'pelanggan_payment_service_bloc.dart';

// Event dasar untuk Payment Service Pelanggan
abstract class PelangganPaymentServiceEvent extends Equatable {
  const PelangganPaymentServiceEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk mengirimkan pembayaran
class SubmitPelangganPaymentService extends PelangganPaymentServiceEvent {
  final PelangganPaymentServiceRequestModel request;

  const SubmitPelangganPaymentService({required this.request});

  @override
  List<Object?> get props => [request];
}

// Event untuk memuat riwayat pembayaran pelanggan
class LoadCustomerServicePayments extends PelangganPaymentServiceEvent {
  const LoadCustomerServicePayments();
}

class LoadPelangganPaymentServiceHistory extends PelangganPaymentServiceEvent {
  const LoadPelangganPaymentServiceHistory(); // Jika tidak ada parameter yang dibutuhkan

  @override
  List<Object> get props => [];
}