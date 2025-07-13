part of 'total_pemasukan_bloc.dart'; // Penting: ini adalah bagian dari file bloc utama

abstract class TotalPemasukanEvent extends Equatable {
  const TotalPemasukanEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk memuat total pemasukan.
class LoadTotalPemasukan extends TotalPemasukanEvent {
  const LoadTotalPemasukan();

  @override
  List<Object> get props => [];
}