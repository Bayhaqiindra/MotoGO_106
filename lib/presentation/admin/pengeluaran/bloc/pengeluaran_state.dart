part of 'pengeluaran_bloc.dart';

abstract class PengeluaranState extends Equatable {
  const PengeluaranState();

  @override
  List<Object> get props => [];
}

class PengeluaranUpdateLoading extends PengeluaranState {
  final List<Datum> pengeluaranList; // Menyimpan data yang sudah ada

  const PengeluaranUpdateLoading({required this.pengeluaranList});

  @override
  List<Object> get props => [pengeluaranList];
}

// State awal atau idle
class PengeluaranInitial extends PengeluaranState {}

// State loading saat operasi sedang berjalan
class PengeluaranLoading extends PengeluaranState {}

// State ketika semua pengeluaran berhasil dimuat
class PengeluaranLoaded extends PengeluaranState {
  final List<Datum> pengeluaranList; // Menggunakan Datum dari GetAllPengeluaranResponseModel

  const PengeluaranLoaded({required this.pengeluaranList});

  @override
  List<Object> get props => [pengeluaranList];
}

// State ketika pengeluaran berhasil ditambahkan
class PengeluaranAdded extends PengeluaranState {
  final AddPengeluaranResponseModel response;

  const PengeluaranAdded({required this.response});

  @override
  List<Object> get props => [response];
}

// State ketika pengeluaran berhasil diperbarui
class PengeluaranUpdated extends PengeluaranState {
  final UpdatePengeluaranResponseModel response;

  const PengeluaranUpdated({required this.response});

  @override
  List<Object> get props => [response];
}

// State ketika pengeluaran berhasil dihapus
class PengeluaranDeleted extends PengeluaranState {
  final DeletePengeluaranResponseModel response;

  const PengeluaranDeleted({required this.response});

  @override
  List<Object> get props => [response];
}

// State error untuk semua operasi
class PengeluaranError extends PengeluaranState {
  final String message;

  const PengeluaranError({required this.message});

  @override
  List<Object> get props => [message];
}