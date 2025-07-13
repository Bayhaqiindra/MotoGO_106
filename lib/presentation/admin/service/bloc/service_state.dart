part of 'service_bloc.dart';

abstract class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceFailure extends ServiceState {
  final String message;
  ServiceFailure(this.message);
}

class ServiceListSuccess extends ServiceState {
  final List<Datum> services;
  ServiceListSuccess(this.services);
}

class ServiceDetailSuccess extends ServiceState {
  final GetByIdServiceResponseModel service;
  ServiceDetailSuccess(this.service);
}

class ServiceAddedSuccess extends ServiceState {
  final AddServiceResponseModel response;
  ServiceAddedSuccess(this.response);
}

class ServiceUpdatedSuccess extends ServiceState {
  final UpdateServiceResponseModel response;
  ServiceUpdatedSuccess(this.response);
}

class ServiceDeletedSuccess extends ServiceState {
  final DeleteServiceResponseModel response;
  ServiceDeletedSuccess(this.response);
}