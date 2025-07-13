part of 'total_pemasukan_bloc.dart'; // Penting: ini adalah bagian dari file bloc utama

abstract class TotalPemasukanState extends Equatable {
  const TotalPemasukanState();

  @override
  List<Object> get props => [];
}

/// State awal sebelum data dimuat.
class TotalPemasukanInitial extends TotalPemasukanState {}

/// State saat data total pemasukan sedang dimuat.
class TotalPemasukanLoading extends TotalPemasukanState {}

/// State saat total pemasukan berhasil dimuat.
class TotalPemasukanLoaded extends TotalPemasukanState {
  final TotalPemasukanResponseModel pemasukanData;

  const TotalPemasukanLoaded({required this.pemasukanData});

  @override
  List<Object> get props => [pemasukanData];
}

/// State saat terjadi kesalahan dalam memuat total pemasukan.
class TotalPemasukanError extends TotalPemasukanState {
  final String message;

  const TotalPemasukanError({required this.message});

  @override
  List<Object> get props => [message];
}