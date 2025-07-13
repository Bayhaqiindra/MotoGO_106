part of 'profile_admin_bloc.dart';

abstract class AdminProfileEvent {}

class GetAdminProfile extends AdminProfileEvent {}

class AddAdminProfile extends AdminProfileEvent {
  final AdminProfileRequestModel requestModel;

  AddAdminProfile({required this.requestModel});
}

class UpdateAdminProfile extends AdminProfileEvent {
  final AdminProfileRequestModel requestModel;

  UpdateAdminProfile({required this.requestModel});
}