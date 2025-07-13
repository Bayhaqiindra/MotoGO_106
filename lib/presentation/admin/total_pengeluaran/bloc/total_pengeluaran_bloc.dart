import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas_akhir/data/repository/admin/total_pengeluaran_repository.dart';

part 'total_pengeluaran_event.dart';
part 'total_pengeluaran_state.dart';

class TotalPengeluaranBloc extends Bloc<TotalPengeluaranEvent, TotalPengeluaranState> {
  final TotalPengeluaranRepository totalPengeluaranRepository;

  TotalPengeluaranBloc({required this.totalPengeluaranRepository}) : super(TotalPengeluaranInitial()) {
    on<LoadTotalPengeluaran>(_onLoadTotalPengeluaran);
  }

  Future<void> _onLoadTotalPengeluaran(
    LoadTotalPengeluaran event,
    Emitter<TotalPengeluaranState> emit,
  ) async {
    emit(TotalPengeluaranLoading());
    try {
      final response = await totalPengeluaranRepository.getTotalPengeluaran();
      // Pastikan total_pengeluaran dari response model adalah double
      // Jika dari backend String, ubah menjadi double di sini
      final total = double.tryParse(response.totalPengeluaran ?? '0.0') ?? 0.0;
      emit(TotalPengeluaranLoaded(total: total));
    } catch (e) {
      emit(TotalPengeluaranError(message: 'Gagal memuat total pengeluaran: ${e.toString()}'));
    }
  }

  
}
