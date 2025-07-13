// lib/presentation/sparepart/bloc/sparepart_event.dart
part of 'sparepart_bloc.dart'; // Menghubungkan file ini sebagai bagian dari sparepart_bloc.dart

@immutable
abstract class SparepartEvent extends Equatable {
  const SparepartEvent();

  @override
  List<Object> get props => [];
}

// Event untuk mengambil semua sparepart
class FetchAllSpareparts extends SparepartEvent {
  const FetchAllSpareparts();
}

// Event untuk mengambil detail sparepart berdasarkan ID
class FetchSparepartById extends SparepartEvent {
  final int id;
  const FetchSparepartById({required this.id});

  @override
  List<Object> get props => [id];
}

// Event untuk membuat sparepart baru (Admin)
class CreateSparepart extends SparepartEvent {
  final CreateSparepartRequestModel request;
  const CreateSparepart({required this.request});

  @override
  List<Object> get props => [request];
}

// Event untuk mengupdate sparepart (Admin)
class UpdateSparepart extends SparepartEvent {
  final int id;
  final UpdateSparepartRequestModel request;
  const UpdateSparepart({required this.id, required this.request});

  @override
  List<Object> get props => [id, request];
}

// Event untuk menghapus sparepart (Admin)
class DeleteSparepart extends SparepartEvent {
  final int id;
  const DeleteSparepart({required this.id});

  @override
  List<Object> get props => [id];
}