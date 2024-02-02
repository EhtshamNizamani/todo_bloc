part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginRequested extends LoginEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}
