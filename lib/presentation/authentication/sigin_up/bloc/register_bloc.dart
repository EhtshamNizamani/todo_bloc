import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_bloc/data/user_model.dart';
import 'package:todo_bloc/domain/failures/firebase_todo_failure.dart';
import 'package:todo_bloc/domain/repositories/user_auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserAuthRepository userAuthRepository;
  RegisterBloc(this.userAuthRepository) : super(RegisterInitial()) {
    on<RegisterUserEvent>(onRegisterUser);
  }
  Future<void> onRegisterUser(
      RegisterUserEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    final userId =
        await userAuthRepository.registerUser(event.email, event.password);

    await userId.fold((error) async {
      return emit(RegisterFailure(error.error));
    }, (userId) async {
      final userResponse = await userAuthRepository
          .setUser(UserModel(id: userId, name: event.name, email: event.email));
      userResponse.fold((error) => emit(RegisterFailure(error.error)), (_) {
        return emit(RegisterSuccess());
      });
      return emit(RegisterSuccess());
    });
  }
}
