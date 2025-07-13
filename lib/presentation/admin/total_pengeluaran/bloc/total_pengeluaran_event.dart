part of 'total_pengeluaran_bloc.dart';

abstract class TotalPengeluaranEvent extends Equatable {
  const TotalPengeluaranEvent();

  @override
  List<Object> get props => [];
}

class LoadTotalPengeluaran extends TotalPengeluaranEvent {
  const LoadTotalPengeluaran();

  @override
  List<Object> get props => [];
}