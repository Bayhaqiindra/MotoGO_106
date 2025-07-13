import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tugas_akhir/data/model/request/admin/payment_service/konfirmasi_payment_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_service/admin_get_all_payment_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_service/konfirmasi_payment_service_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/admin_payment_service_repository.dart';

part 'admin_payment_service_event.dart';
part 'admin_payment_service_state.dart';

class AdminPaymentServiceBloc extends Bloc<
    AdminPaymentServiceEvent, AdminPaymentServiceState> {
  final IAdminPaymentServiceRepository adminPaymentServiceRepository;

  AdminPaymentServiceBloc({
    required this.adminPaymentServiceRepository,
  }) : super(AdminPaymentServiceInitial()) {
    on<LoadAllAdminServicePayments>(_onLoadAllAdminServicePayments);
    on<VerifyAdminServicePayment>(_onVerifyAdminServicePayment);
  }

  Future<void> _onLoadAllAdminServicePayments(
    LoadAllAdminServicePayments event,
    Emitter<AdminPaymentServiceState> emit,
  ) async {
    emit(AdminPaymentServiceLoading());
    if (kDebugMode) {
      print('[DEBUG] BLoC: Loading all admin service payments...');
    }
    final result = await adminPaymentServiceRepository.getAllAdminServicePayments();
    result.fold(
      (error) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: Failed to load all admin service payments: $error');
        }
        emit(AdminPaymentServiceFailure(error));
      },
      (payments) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: All admin service payments loaded successfully. Count: ${payments.length}');
        }
        emit(AllAdminServicePaymentsLoaded(payments: payments));
      },
    );
  }

  Future<void> _onVerifyAdminServicePayment(
    VerifyAdminServicePayment event,
    Emitter<AdminPaymentServiceState> emit,
  ) async {
    emit(AdminPaymentServiceLoading());
    if (kDebugMode) {
      print('[DEBUG] BLoC: Verifying admin service payment with ID: ${event.paymentId}...');
    }
    final result = await adminPaymentServiceRepository.verifyPayment(
      event.paymentId,
      event.request,
    );
    result.fold(
      (error) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: Admin payment verification failed: $error');
        }
        emit(AdminPaymentServiceFailure(error));
      },
      (response) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: Admin payment verified successfully.');
        }
        emit(AdminServicePaymentVerified(response: response));
        // Opsional: Setelah verifikasi berhasil, Anda mungkin ingin memuat ulang daftar pembayaran
        // add(const LoadAllAdminServicePayments());
      },
    );
  }
}