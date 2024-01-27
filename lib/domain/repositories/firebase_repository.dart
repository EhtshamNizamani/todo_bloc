import 'package:dartz/dartz.dart';
import 'package:todo_bloc/data/todo_model.dart';
import 'package:todo_bloc/domain/failures/firebase_todo_failure.dart';
import 'package:todo_bloc/domain/success/firebase_todo_success.dart';

abstract class FirebaseRepository {
  Future<Either<FirebaseTodoFailure, List<TodoModel>>> getAllTodo();
  Future<Either<FirebaseTodoFailure, FirebaseTodoSuccess>> addTodo(
      TodoModel todoModel);

  Future<Either<FirebaseTodoFailure, FirebaseTodoSuccess>> deleteTodoById(
      String id);

  Future<Either<FirebaseTodoFailure, FirebaseTodoSuccess>> completeTodoById(
      TodoModel todo);
}
