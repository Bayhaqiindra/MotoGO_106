part of 'profile_pelanggan_bloc.dart';


abstract class PelangganProfileEvent {}

// Event untuk mengambil (GET) data profil
class GetPelangganProfile extends PelangganProfileEvent {}

// Event untuk menambahkan (ADD) data profil baru
class AddPelangganProfile extends PelangganProfileEvent {
  final PelangganProfileRequestModel requestModel;

  AddPelangganProfile({required this.requestModel});
}

// Event untuk memperbarui (UPDATE) data profil
class UpdatePelangganProfile extends PelangganProfileEvent {
  final PelangganProfileRequestModel requestModel;

  UpdatePelangganProfile({required this.requestModel});
}