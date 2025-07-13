part of 'service_bloc.dart';

abstract class ServiceEvent {}

class GetAllServiceEvent extends ServiceEvent {}

class GetServiceByIdEvent extends ServiceEvent {
  final int id;
  GetServiceByIdEvent(this.id);
}

class AddServiceEvent extends ServiceEvent {
  final ServiceRequestModel request;
  AddServiceEvent(this.request);
}

class UpdateServiceEvent extends ServiceEvent {
  final int id;
  final ServiceRequestModel request;
  UpdateServiceEvent(this.id, this.request);
}

class DeleteServiceEvent extends ServiceEvent {
  final int id;
  DeleteServiceEvent(this.id);
}