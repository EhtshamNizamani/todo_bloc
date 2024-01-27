import 'package:equatable/equatable.dart';
import 'package:todo_bloc/data/todo_model.dart';

class TodoState extends Equatable {
  final List<TodoModel> todoList;
  final bool isLoading;
  final String? error;

  const TodoState({
    required this.todoList,
    required this.isLoading,
    this.error,
  });

  factory TodoState.empty() => const TodoState(
        todoList: [],
        isLoading: false,
      );

  TodoState copyWith({
    List<TodoModel>? todos,
    bool? isLoading,
    String? error,
  }) =>
      TodoState(
        todoList: todos ?? this.todoList,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [todoList, isLoading, error];
}
