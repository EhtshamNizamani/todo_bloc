import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_bloc/domain/repositories/firebase_repository.dart';
import 'package:todo_bloc/domain/repositories/user_auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserAuthRepository userAuthRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc(this.userAuthRepository) : super(AuthenticationInitial()) {
    _userSubscription = userAuthRepository.user.listen((user) async {
      await Future.delayed(const Duration(seconds: 2));
      add(AuthenticationUserChanged(user));
    });
    on<AuthenticationUserChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationFail());
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
    // Print information about the change
    print('${change.currentState} -> ${change.nextState}');
  }
}
