// lib/presentation/admin/payment_sparepart/bloc/admin_payment_sparepart_event.dart

part of 'admin_payment_sparepart_bloc.dart';

@immutable
sealed class AdminPaymentSparepartEvent extends Equatable {
  const AdminPaymentSparepartEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk mengambil semua riwayat pembayaran sparepart pelanggan oleh admin.
class FetchAllAdminPaymentsSparepart extends AdminPaymentSparepartEvent {
  const FetchAllAdminPaymentsSparepart();

  @override
  List<Object> get props => [];
}

/// Event untuk mengkonfirmasi (memverifikasi) status pembayaran sparepart oleh admin.
class ConfirmAdminPaymentSparepart extends AdminPaymentSparepartEvent {
  final int paymentId;
  final KonfirmasiPaymentSparepartRequestModel requestModel;

  const ConfirmAdminPaymentSparepart({
    required this.paymentId,
    required this.requestModel,
  });

  @override
  List<Object> get props => [paymentId, requestModel];
}