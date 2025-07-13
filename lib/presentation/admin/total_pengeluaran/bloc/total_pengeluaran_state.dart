part of 'total_pengeluaran_bloc.dart';

abstract class TotalPengeluaranState extends Equatable {
  const TotalPengeluaranState();

  @override
  List<Object> get props => [];
}

class TotalPengeluaranInitial extends TotalPengeluaranState {}

class TotalPengeluaranLoading extends TotalPengeluaranState {}

class TotalPengeluaranLoaded extends TotalPengeluaranState {
  final double total;

  const TotalPengeluaranLoaded({required this.total});

  @override
  List<Object> get props => [total];
}

class TotalPengeluaranError extends TotalPengeluaranState {
  final String message;

  const TotalPengeluaranError({required this.message});

  @override
  List<Object> get props => [message];
}

