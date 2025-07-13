import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas_akhir/data/model/response/admin/total_pemasukan/total_pemasukan_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/admin_total_pemasukan_repository.dart';

part 'total_pemasukan_event.dart';
part 'total_pemasukan_state.dart';

class TotalPemasukanBloc extends Bloc<TotalPemasukanEvent, TotalPemasukanState> {
  final TotalPemasukanRepository totalPemasukanRepository;

  /// Constructor untuk TotalPemasukanBloc.
  /// Menerima TotalPemasukanRepository dan menginisialisasi state awal ke TotalPemasukanInitial.
  TotalPemasukanBloc({required this.totalPemasukanRepository}) : super(TotalPemasukanInitial()) {
    // Mendaftarkan handler untuk event LoadTotalPemasukan
    on<LoadTotalPemasukan>(_onLoadTotalPemasukan);
  }

  /// Handler untuk event LoadTotalPemasukan.
  /// Mengambil data total pemasukan dari repository dan memancarkan state.
  Future<void> _onLoadTotalPemasukan(
    LoadTotalPemasukan event,
    Emitter<TotalPemasukanState> emit,
  ) async {
    emit(TotalPemasukanLoading()); // Pancarkan state loading
    try {
      final response = await totalPemasukanRepository.getTotalPemasukan(); // Panggil repository
      emit(TotalPemasukanLoaded(pemasukanData: response)); // Pancarkan state loaded dengan data
    } catch (e) {
      // Jika terjadi error, pancarkan state error
      emit(TotalPemasukanError(message: 'Gagal memuat total pemasukan: ${e.toString()}'));
    }
  }
}