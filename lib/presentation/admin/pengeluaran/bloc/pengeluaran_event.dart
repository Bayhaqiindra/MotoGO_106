part of 'pengeluaran_bloc.dart';

abstract class PengeluaranEvent extends Equatable {
  const PengeluaranEvent();

  @override
  List<Object> get props => [];
}

// Event untuk memuat semua pengeluaran
class LoadPengeluaran extends PengeluaranEvent {
  const LoadPengeluaran();
}

// Event untuk menambahkan pengeluaran baru
class AddPengeluaran extends PengeluaranEvent {
  final AddPengeluaranRequestModel request;

  const AddPengeluaran({required this.request});

  @override
  List<Object> get props => [request];
}

// Event untuk memperbarui pengeluaran
class UpdatePengeluaran extends PengeluaranEvent {
  final int id;
  final UpdatePengeluaranRequestModel request;

  const UpdatePengeluaran({required this.id, required this.request});

  @override
  List<Object> get props => [id, request];
}

// Event untuk menghapus pengeluaran
class DeletePengeluaran extends PengeluaranEvent {
  final int id;

  const DeletePengeluaran({required this.id});

  @override
  List<Object> get props => [id];
}
