part of 'profile_admin_bloc.dart';

abstract class AdminProfileState {}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileSuccess extends AdminProfileState {
  final AdminProfileResponseModel responseModel;

  AdminProfileSuccess({required this.responseModel});
}

class AdminProfileFailure extends AdminProfileState {
  final String error;

  AdminProfileFailure({required this.error});
}