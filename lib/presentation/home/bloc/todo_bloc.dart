import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo_bloc/data/todo_model.dart';
import 'package:todo_bloc/data/firebase_todo_repository.dart';
import 'package:todo_bloc/domain/repositories/firebase_repository.dart';
import 'package:todo_bloc/presentation/home/bloc/todo_state.dart';

part 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FirebaseRepository firebaseTodoRepository;
  TodoBloc(this.firebaseTodoRepository) : super(TodoState.empty()) {
    on<GetAllTodo>(onGetAllTodo);
    on<AddTodo>(onAddTodo);
    on<DoneTodo>(onDoneTodo);
    on<DeleteTodo>(onDeleteTodo);
  }
  Future<void> onGetAllTodo(GetAllTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(isLoading: true));
    final firebaseResponse = await firebaseTodoRepository.getAllTodo();
    firebaseResponse.fold((error) {
      emit(state.copyWith(isLoading: false, error: error.error));
    }, (todos) {
      print(todos);
      emit(state.copyWith(todos: todos, isLoading: false));
    });
  }

  void onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(isLoading: true));

    final firebaseResponse =
        await firebaseTodoRepository.addTodo(event.addTodo);
    await firebaseResponse.fold((error) {
      print('added error successfully $state ${error.error} ');

      emit(state.copyWith(error: error.error, isLoading: false));
    }, (success) async {
      print('added successfully $state');

      // Retrieve all todos after adding a new one
      final todosResponse = await firebaseTodoRepository.getAllTodo();
      todosResponse.fold((error) {
        emit(state.copyWith(error: error.error, isLoading: false));
      }, (todos) {
        emit(state.copyWith(todos: todos, isLoading: false));
      });
    });
  }

  Future<void> onDoneTodo(DoneTodo event, Emitter<TodoState> emit) async {
    final firebaseResponse =
        await firebaseTodoRepository.completeTodoById(event.doneTodo);

    await firebaseResponse.fold((error) {
      emit(state.copyWith(error: error.error));
    }, (r) async {
      final getAllTodo = await firebaseTodoRepository.getAllTodo();
      getAllTodo.fold((error) {
        emit(state.copyWith(error: error.error));
      }, (todos) {
        emit(state.copyWith(todos: todos, isLoading: false));
      });
    });
  }

  void onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    final todo = event.deleteTodo;
    final todoId = await firebaseTodoRepository.deleteTodoById(todo.id);
    emit(state.copyWith(isLoading: true));

    await todoId.fold((error) {
      emit(state.copyWith(error: error.error, isLoading: false));
    }, (r) async {
      final todosResponse = await firebaseTodoRepository.getAllTodo();
      todosResponse.fold((error) {
        emit(state.copyWith(error: error.error, isLoading: false));
      }, (todos) {
        emit(state.copyWith(todos: todos, isLoading: false));

        // emit(state.copyWith(todos: todos, isLoading: false));
      });
    });
    List<TodoModel> allTodo = List.from(state.todoList)..remove(todo);

    emit(state.copyWith(todos: allTodo));
  }
}
