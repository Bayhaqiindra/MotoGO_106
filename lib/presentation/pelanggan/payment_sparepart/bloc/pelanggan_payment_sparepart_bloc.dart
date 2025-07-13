import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/payment_sparepart/submit_payment_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_sparepart/get_all_payment_response_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/payment_sparepart/submit_payment_response_model.dart';
import 'package:tugas_akhir/data/repository/pelanggan/payment_sparepart_repository.dart';

part 'pelanggan_payment_sparepart_event.dart';
part 'pelanggan_payment_sparepart_state.dart';

class PelangganPaymentSparepartBloc extends Bloc<PelangganPaymentSparepartEvent, PelangganPaymentSparepartState> {
  final PelangganPaymentSparepartRepository _repository;

  PelangganPaymentSparepartBloc(this._repository) : super(PelangganPaymentSparepartInitial()) {
    on<SubmitPelangganPaymentSparepart>(_mapSubmitPaymentToState);
    on<LoadPelangganPaymentSparepartHistory>(_mapLoadHistoryToState);
  }

  /// Handler untuk event SubmitPelangganPaymentSparepart
  Future<void> _mapSubmitPaymentToState(
    SubmitPelangganPaymentSparepart event,
    Emitter<PelangganPaymentSparepartState> emit,
  ) async {
    emit(PelangganPaymentSparepartLoading());
    try {
      final response = await _repository.submitPaymentSparepart(event.requestModel);
      emit(PelangganPaymentSparepartSubmitSuccess(response));
    } catch (e) {
      emit(PelangganPaymentSparepartError(e.toString()));
    }
  }

  /// Handler untuk event LoadPelangganPaymentSparepartHistory
  Future<void> _mapLoadHistoryToState(
    LoadPelangganPaymentSparepartHistory event,
    Emitter<PelangganPaymentSparepartState> emit,
  ) async {
    emit(PelangganPaymentSparepartLoading());
    try {
      final payments = await _repository.getCustomerPaymentsSparepart();
      emit(PelangganPaymentSparepartHistoryLoaded(payments));
    } catch (e) {
      emit(PelangganPaymentSparepartError(e.toString()));
    }
  }
}