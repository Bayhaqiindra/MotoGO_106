// lib/presentation/sparepart/bloc/sparepart_state.dart
part of 'sparepart_bloc.dart'; // Menghubungkan file ini sebagai bagian dari sparepart_bloc.dart

@immutable
abstract class SparepartState extends Equatable {
  const SparepartState();

  @override
  List<Object> get props => [];
}

// State awal
class SparepartInitial extends SparepartState {}

// State ketika sedang loading
class SparepartLoading extends SparepartState {}

// State ketika semua sparepart berhasil diambil
class AllSparepartsLoaded extends SparepartState {
  final List<GetallSparepartResponseModel> spareparts;
  const AllSparepartsLoaded({required this.spareparts});

  @override
  List<Object> get props => [spareparts];
}

// State ketika detail sparepart berhasil diambil
class SparepartByIdLoaded extends SparepartState {
  final GetSparepartByIdResponseModel sparepart;
  const SparepartByIdLoaded({required this.sparepart});

  @override
  List<Object> get props => [sparepart];
}

// State ketika sparepart berhasil dibuat
class SparepartCreatedSuccess extends SparepartState {
  final String message;
  final AddAdminSparepartResponseModel response; // Opsional, bisa juga hanya message
  const SparepartCreatedSuccess({required this.message, required this.response});

  @override
  List<Object> get props => [message, response];
}

// State ketika sparepart berhasil diupdate
class SparepartUpdatedSuccess extends SparepartState {
  final String message;
  final UpdateSparepartResponseModel response; // Opsional, bisa juga hanya message
  const SparepartUpdatedSuccess({required this.message, required this.response});

  @override
  List<Object> get props => [message, response];
}

// State ketika sparepart berhasil dihapus
class SparepartDeletedSuccess extends SparepartState {
  final String message;
  final DeleteSparepartResponseModel response; // Opsional, bisa juga hanya message
  const SparepartDeletedSuccess({required this.message, required this.response});

  @override
  List<Object> get props => [message, response];
}

// State ketika terjadi kegagalan
class SparepartError extends SparepartState {
  final String message;
  const SparepartError({required this.message});

  @override
  List<Object> get props => [message];
}