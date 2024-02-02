part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegisterEvent {
  final String email;
  final String password;
  final String name;

  const RegisterUserEvent(this.email, this.password, this.name);

  @override
  List<Object> get props => [email, password];
}
