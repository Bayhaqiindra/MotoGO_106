// lib/presentation/admin/payment_sparepart/bloc/admin_payment_sparepart_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // Digunakan untuk @immutable
import 'package:tugas_akhir/data/model/request/admin/payment_sparepart/konfirmasi_payment_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_sparepart/admin_get_all_payment_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/payment_sparepart/konfirmasi_payment_sparepart_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/admin_konfirmasi_payment_sparepart_repository.dart';

part 'admin_payment_sparepart_event.dart';
part 'admin_payment_sparepart_state.dart';

class AdminPaymentSparepartBloc extends Bloc<AdminPaymentSparepartEvent, AdminPaymentSparepartState> {
  final AdminPaymentSparepartRepository _repository;

  AdminPaymentSparepartBloc(this._repository) : super(AdminPaymentSparepartInitial()) {
    on<FetchAllAdminPaymentsSparepart>(_onFetchAllAdminPaymentsSparepart);
    on<ConfirmAdminPaymentSparepart>(_onConfirmAdminPaymentSparepart);
  }

  Future<void> _onFetchAllAdminPaymentsSparepart(
    FetchAllAdminPaymentsSparepart event,
    Emitter<AdminPaymentSparepartState> emit,
  ) async {
    emit(AdminPaymentsSparepartLoading());
    try {
      final payments = await _repository.getAllAdminPaymentsSparepart();
      emit(AdminPaymentsSparepartLoaded(payments));
    } catch (e) {
      emit(AdminPaymentsSparepartError(e.toString()));
    }
  }

  Future<void> _onConfirmAdminPaymentSparepart(
    ConfirmAdminPaymentSparepart event,
    Emitter<AdminPaymentSparepartState> emit,
  ) async {
    emit(AdminPaymentSparepartConfirmationLoading());
    try {
      final response = await _repository.verifyPaymentSparepart(
        paymentId: event.paymentId,
        requestModel: event.requestModel,
      );
      emit(AdminPaymentSparepartConfirmationSuccess(response));
      // Setelah sukses konfirmasi, mungkin Anda ingin memuat ulang daftar pembayaran
      // agar UI diperbarui. Ini bisa dilakukan dengan memancarkan event FetchAllAdminPaymentsSparepart
      // atau dengan mekanisme lain di UI (misalnya, setelah navigasi pop dari halaman konfirmasi).
      // Contoh: add(const FetchAllAdminPaymentsSparepart());
    } catch (e) {
      emit(AdminPaymentSparepartConfirmationError(e.toString()));
    }
  }
}