part of 'profile_pelanggan_bloc.dart';

// Tanpa @immutable
abstract class PelangganProfileState {}

// State awal: sebelum ada operasi
class PelangganProfileInitial extends PelangganProfileState {}

// State saat sedang memuat data (loading)
class PelangganProfileLoading extends PelangganProfileState {}

// State ketika operasi (get/add/update) berhasil
class PelangganProfileSuccess extends PelangganProfileState {
  final PelangganProfileResponseModel responseModel;

  PelangganProfileSuccess({required this.responseModel});
}

// State ketika operasi (get/add/update) gagal
class PelangganProfileFailure extends PelangganProfileState {
  final String error;

  PelangganProfileFailure({required this.error});
}