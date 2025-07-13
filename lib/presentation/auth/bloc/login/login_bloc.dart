import 'package:bloc/bloc.dart';
import 'package:tugas_akhir/data/model/request/auth/login_request_model.dart';
import 'package:tugas_akhir/data/model/response/auth/login_response_model.dart';
import 'package:tugas_akhir/data/repository/auth/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await authRepository.login(event.requestModel);

    result.fold(
      (failure) => emit(LoginFailure(error: failure)),
      (success) => emit(LoginSuccess(responseModel: success)),
    );
  }
}
