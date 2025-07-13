import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/payment_service/pelanggan_payment_service_request_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_service/get_all_payment_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_service/pelanggan_payment_service_response_model.dart';
import 'package:tugas_akhir/data/repository/pelanggan/payment_service_repository.dart';

part 'pelanggan_payment_service_event.dart';
part 'pelanggan_payment_service_state.dart';

class PelangganPaymentServiceBloc extends Bloc<
    PelangganPaymentServiceEvent, PelangganPaymentServiceState> {
  final IPelangganPaymentServiceRepository pelangganPaymentServiceRepository;

  PelangganPaymentServiceBloc({
    required this.pelangganPaymentServiceRepository,
  }) : super(PelangganPaymentServiceInitial()) {
    on<SubmitPelangganPaymentService>(_onSubmitPelangganPaymentService);
    on<LoadCustomerServicePayments>(_onLoadCustomerServicePayments);
  }

  Future<void> _onSubmitPelangganPaymentService(
    SubmitPelangganPaymentService event,
    Emitter<PelangganPaymentServiceState> emit,
  ) async {
    emit(PelangganPaymentServiceLoading());
    if (kDebugMode) {
      print('[DEBUG] BLoC: Submitting customer payment...');
    }
    final result = await pelangganPaymentServiceRepository.submitPayment(event.request);
    result.fold(
      (error) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: Customer payment submission failed: $error');
        }
        emit(PelangganPaymentServiceFailure(error));
      },
      (response) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: Customer payment submitted successfully.');
        }
        emit(PelangganPaymentServiceSubmissionSuccess(response: response));
      },
    );
  }

  Future<void> _onLoadCustomerServicePayments(
    LoadCustomerServicePayments event,
    Emitter<PelangganPaymentServiceState> emit,
  ) async {
    emit(PelangganPaymentServiceLoading());
    if (kDebugMode) {
      print('[DEBUG] BLoC: Loading customer service payments...');
    }
    final result = await pelangganPaymentServiceRepository.getCustomerServicePayments();
    result.fold(
      (error) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: Failed to load customer service payments: $error');
        }
        emit(PelangganPaymentServiceFailure(error));
      },
      (payments) {
        if (kDebugMode) {
          print('[DEBUG] BLoC: Customer service payments loaded successfully. Count: ${payments.length}');
        }
        emit(CustomerServicePaymentsLoaded(payments: payments));
      },
    );
  }
}
