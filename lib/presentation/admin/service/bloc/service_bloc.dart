// service_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/data/model/request/admin/service/service_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/add_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/delete_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_by_id_service_response_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/update_service_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final AdminServiceRepository repository;

  ServiceBloc(this.repository) : super(ServiceInitial()) {
    on<GetAllServiceEvent>(_onGetAll);
    on<GetServiceByIdEvent>(_onGetById);
    on<AddServiceEvent>(_onAddService);
    on<UpdateServiceEvent>(_onUpdateService);
    on<DeleteServiceEvent>(_onDeleteService);
  }

  Future<void> _onGetAll(GetAllServiceEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    final result = await repository.getAllServices();
    result.fold(
      (error) => emit(ServiceFailure(error)),
      (data) => emit(ServiceListSuccess(data)),
    );
  }

  Future<void> _onGetById(GetServiceByIdEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    final result = await repository.getServiceById(event.id);
    result.fold(
      (error) => emit(ServiceFailure(error)),
      (data) => emit(ServiceDetailSuccess(data)),
    );
  }

  Future<void> _onAddService(AddServiceEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    final result = await repository.addService(event.request);
    result.fold(
      (error) => emit(ServiceFailure(error)),
      (data) => emit(ServiceAddedSuccess(data)),
    );
  }

  Future<void> _onUpdateService(UpdateServiceEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    final result = await repository.updateService(event.id, event.request);
    result.fold(
      (error) => emit(ServiceFailure(error)),
      (data) => emit(ServiceUpdatedSuccess(data)),
    );
  }

  Future<void> _onDeleteService(DeleteServiceEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    final result = await repository.deleteService(event.id);
    result.fold(
      (error) => emit(ServiceFailure(error)),
      (data) => emit(ServiceDeletedSuccess(data)),
    );
  }
}
