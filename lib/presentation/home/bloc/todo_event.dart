// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTodo extends TodoEvent {
  final TodoModel addTodo;
  AddTodo({
    required this.addTodo,
  });

  @override
  List<Object?> get props => [addTodo];
}

class GetAllTodo extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class DeleteTodo extends TodoEvent {
  final TodoModel deleteTodo;
  DeleteTodo({
    required this.deleteTodo,
  });

  @override
  List<Object?> get props => [deleteTodo];
}

class DoneTodo extends TodoEvent {
  final TodoModel doneTodo;
  DoneTodo({
    required this.doneTodo,
  });

  @override
  List<Object?> get props => [doneTodo];
}
