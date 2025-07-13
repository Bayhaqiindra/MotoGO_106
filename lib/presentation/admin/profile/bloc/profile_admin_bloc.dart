import 'package:bloc/bloc.dart';
import 'package:tugas_akhir/data/model/request/admin/profile/admin_profile_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/profile/admin_profile_response_model.dart';
import 'package:tugas_akhir/data/repository/admin/admin_profile_repository.dart';

part 'profile_admin_event.dart';
part 'profile_admin_state.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  final AdminProfileRepository repository;

  AdminProfileBloc({required this.repository}) : super(AdminProfileInitial()) {
    on<GetAdminProfile>((event, emit) async {
      emit(AdminProfileLoading());
      final result = await repository.getProfile();
      result.fold(
        (error) => emit(AdminProfileFailure(error: error)),
        (response) => emit(AdminProfileSuccess(responseModel: response)),
      );
    });

    on<AddAdminProfile>((event, emit) async {
      emit(AdminProfileLoading());
      final result = await repository.addProfile(event.requestModel);
      result.fold(
        (error) => emit(AdminProfileFailure(error: error)),
        (response) => emit(AdminProfileSuccess(responseModel: response)),
      );
    });

    on<UpdateAdminProfile>((event, emit) async {
      emit(AdminProfileLoading());
      final result = await repository.updateProfile(event.requestModel);
      result.fold(
        (error) => emit(AdminProfileFailure(error: error)),
        (response) => emit(AdminProfileSuccess(responseModel: response)),
      );
    });
  }
}