import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_bloc/data/user_model.dart';
import 'package:todo_bloc/domain/failures/firebase_todo_failure.dart';
import 'package:todo_bloc/domain/success/firebase_todo_success.dart';

abstract class UserAuthRepository {
  Stream<User?> get user;
  Future<Either<Failure, String>> registerUser(String email, String password);
  Future<Either<Failure, Success>> loginUser(String email, String password);

  Future<Either<Failure, Success>> setUser(UserModel user);
}
