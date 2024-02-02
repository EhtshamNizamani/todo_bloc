part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class InitialState extends LoginState {}

final class SuccessState extends LoginState {}

final class LoadingState extends LoginState {}

final class ErrorState extends LoginState {
  final String? error;
  const ErrorState(this.error);
}
