// lib/presentation/sparepart/bloc/sparepart_bloc.dart

import 'dart:async';
import 'dart:io'; // Diperlukan karena request model menggunakan File

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tugas_akhir/data/model/request/admin/sparepart/admin_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/request/admin/sparepart/update_sparepart_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/add_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/delete_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_all_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/get_by_id_sparepart_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/sparepart/update_sparepart_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/sparepart_repository.dart';




part 'sparepart_event.dart';
part 'sparepart_state.dart';

class SparepartBloc extends Bloc<SparepartEvent, SparepartState> {
  final ISparepartRepository sparepartRepository;

  SparepartBloc({required this.sparepartRepository}) : super(SparepartInitial()) {
    on<FetchAllSpareparts>(_onFetchAllSpareparts);
    on<FetchSparepartById>(_onFetchSparepartById);
    on<CreateSparepart>(_onCreateSparepart);
    on<UpdateSparepart>(_onUpdateSparepart);
    on<DeleteSparepart>(_onDeleteSparepart);
  }

  FutureOr<void> _onFetchAllSpareparts(
      FetchAllSpareparts event, Emitter<SparepartState> emit) async {
    emit(SparepartLoading());
    final result = await sparepartRepository.getAllSpareparts();
    result.fold(
      (failure) => emit(SparepartError(message: failure)),
      (spareparts) => emit(AllSparepartsLoaded(spareparts: spareparts)),
    );
  }

  FutureOr<void> _onFetchSparepartById(
      FetchSparepartById event, Emitter<SparepartState> emit) async {
    emit(SparepartLoading());
    final result = await sparepartRepository.getSparepartById(event.id);
    result.fold(
      (failure) => emit(SparepartError(message: failure)),
      (sparepart) => emit(SparepartByIdLoaded(sparepart: sparepart)),
    );
  }

  FutureOr<void> _onCreateSparepart(
      CreateSparepart event, Emitter<SparepartState> emit) async {
    emit(SparepartLoading());
    final result = await sparepartRepository.createSparepart(event.request);
    result.fold(
      (failure) => emit(SparepartError(message: failure)),
      (response) => emit(SparepartCreatedSuccess(
          message: response.message ?? 'Sparepart berhasil dibuat', response: response)),
    );
  }

  FutureOr<void> _onUpdateSparepart(
      UpdateSparepart event, Emitter<SparepartState> emit) async {
    emit(SparepartLoading());
    final result = await sparepartRepository.updateSparepart(event.id, event.request);
    result.fold(
      (failure) => emit(SparepartError(message: failure)),
      (response) => emit(SparepartUpdatedSuccess(
          message: response.message ?? 'Sparepart berhasil diperbarui', response: response)),
    );
  }

  FutureOr<void> _onDeleteSparepart(
      DeleteSparepart event, Emitter<SparepartState> emit) async {
    emit(SparepartLoading());
    final result = await sparepartRepository.deleteSparepart(event.id);
    result.fold(
      (failure) => emit(SparepartError(message: failure)),
      (response) => emit(SparepartDeletedSuccess(
          message: response.message ?? 'Sparepart berhasil dihapus', response: response)),
    );
  }
}