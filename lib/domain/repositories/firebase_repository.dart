import 'package:dartz/dartz.dart';
import 'package:todo_bloc/data/todo_model.dart';
import 'package:todo_bloc/domain/failures/firebase_todo_failure.dart';
import 'package:todo_bloc/domain/success/firebase_todo_success.dart';

abstract class FirebaseRepository {
  Future<Either<Failure, List<TodoModel>>> getAllTodo();
  Future<Either<Failure, Success>> addTodo(TodoModel todoModel);

  Future<Either<Failure, Success>> deleteTodoById(String id);

  Future<Either<Failure, Success>> completeTodoById(TodoModel todo);

  Future<Either<Failure, Success>> logoutUser();
}
