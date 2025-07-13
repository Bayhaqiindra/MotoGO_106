import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas_akhir/data/model/request/admin/pengeluaran/add_pengeluaran_request_model.dart';
import 'package:tugas_akhir/data/model/request/admin/pengeluaran/update_pengeluaran_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/add_pengeluaran_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/delete_pengeluaran_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/get_all_pengeluaran_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/pengeluaran/update_pengeluaran_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/admin_pengeluaran_repository.dart';

part 'pengeluaran_event.dart';
part 'pengeluaran_state.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState> {
  final PengeluaranRepository pengeluaranRepository;

  PengeluaranBloc({required this.pengeluaranRepository}) : super(PengeluaranInitial()) {
    on<LoadPengeluaran>(_onLoadPengeluaran);
    on<AddPengeluaran>(_onAddPengeluaran);
    on<UpdatePengeluaran>(_onUpdatePengeluaran);
    on<DeletePengeluaran>(_onDeletePengeluaran);

  }

  Future<void> _onLoadPengeluaran(
    LoadPengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    try {
      final response = await pengeluaranRepository.getAllPengeluaran();
      if (response.data != null) {
        emit(PengeluaranLoaded(pengeluaranList: response.data!));
      } else {
        emit(const PengeluaranError(message: 'Data pengeluaran kosong.'));
      }
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onAddPengeluaran(
    AddPengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading()); // Bisa juga menggunakan state terpisah seperti PengeluaranAdding
    try {
      final response = await pengeluaranRepository.addPengeluaran(event.request);
      emit(PengeluaranAdded(response: response));
      // Opsional: Setelah menambah, muat ulang daftar pengeluaran
      add(const LoadPengeluaran());
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePengeluaran(
    UpdatePengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading()); // Bisa juga menggunakan state terpisah seperti PengeluaranUpdating
    try {
      final response = await pengeluaranRepository.updatePengeluaran(event.id, event.request);
      emit(PengeluaranUpdated(response: response));
      // Opsional: Setelah update, muat ulang daftar pengeluaran
      add(const LoadPengeluaran());
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }

  Future<void> _onDeletePengeluaran(
    DeletePengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading()); // Bisa juga menggunakan state terpisah seperti PengeluaranDeleting
    try {
      final response = await pengeluaranRepository.deletePengeluaran(event.id);
      emit(PengeluaranDeleted(response: response));
      // Opsional: Setelah delete, muat ulang daftar pengeluaran
      add(const LoadPengeluaran());
    } catch (e) {
      emit(PengeluaranError(message: e.toString()));
    }
  }


}
