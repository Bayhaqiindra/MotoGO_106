import 'package:bloc/bloc.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/pelanggan_profile_request_model.dart';
import 'package:tugas_akhir/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:tugas_akhir/data/repository/pelanggan_profile_repository.dart';

part 'profile_pelanggan_event.dart';
part 'profile_pelanggan_state.dart';

class PelangganProfileBloc extends Bloc<PelangganProfileEvent, PelangganProfileState> {
  final PelangganProfileRepository repository;

  PelangganProfileBloc({required this.repository}) : super(PelangganProfileInitial()) {
    on<GetPelangganProfile>((event, emit) async {
      emit(PelangganProfileLoading());
      final result = await repository.getPelangganProfile();
      result.fold(
        (error) => emit(PelangganProfileFailure(error: error)),
        (response) => emit(PelangganProfileSuccess(responseModel: response)),
      );
    });

    on<AddPelangganProfile>((event, emit) async {
      emit(PelangganProfileLoading());
      final result = await repository.addPelangganProfile(event.requestModel);
      result.fold(
        (error) => emit(PelangganProfileFailure(error: error)),
        (response) => emit(PelangganProfileSuccess(responseModel: response)),
      );
    });

    on<UpdatePelangganProfile>((event, emit) async {
      emit(PelangganProfileLoading());
      final result = await repository.updatePelangganProfile(event.requestModel);
      result.fold(
        (error) => emit(PelangganProfileFailure(error: error)),
        (response) => emit(PelangganProfileSuccess(responseModel: response)),
      );
    });
  }
}