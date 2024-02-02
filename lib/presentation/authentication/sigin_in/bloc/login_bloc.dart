import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_bloc/domain/repositories/user_auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserAuthRepository userAuthRepository;
  LoginBloc(this.userAuthRepository) : super(InitialState()) {
    on<LoginRequested>(onLoginRequested);
  }

  Future<void> onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    final loginResponse =
        await userAuthRepository.loginUser(event.email, event.password);
    loginResponse.fold((error) {
      print(error.error);
      return emit(ErrorState(error.error));
    }, (_) {
      return emit(SuccessState());
    });
  }
}
