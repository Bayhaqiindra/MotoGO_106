part of 'register_bloc.dart';

sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponseModel responseModel;

  RegisterSuccess({required this.responseModel});
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});
}
