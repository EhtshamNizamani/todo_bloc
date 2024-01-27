import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_bloc/data/todo_model.dart';
import 'package:todo_bloc/domain/failures/firebase_todo_failure.dart';
import 'package:todo_bloc/domain/repositories/firebase_repository.dart';
import 'package:todo_bloc/domain/success/firebase_todo_success.dart';

class FirebaseTodoRepository implements FirebaseRepository {
  @override
  Future<Either<FirebaseTodoFailure, List<TodoModel>>> getAllTodo() async {
    try {
      // Fetch data from Firestore using await
      final querySnapshot =
          await FirebaseFirestore.instance.collection('todoAPP').get();

      // Process the retrieved documents
      final todos = querySnapshot.docs.map((todo) {
        return TodoModel(
            id: todo['id'],
            title: todo['title'],
            description: todo['description'],
            dateTime: DateTime.fromMillisecondsSinceEpoch(todo['dateTime']),
            completed: todo['completed'] ?? false);
      }).toList();

      return right(todos);
    } catch (ex) {
      // Handle errors
      return left(FirebaseTodoFailure(error: 'Error fetching todos: $ex'));
    }
  }

  @override
  Future<Either<FirebaseTodoFailure, FirebaseTodoSuccess>> addTodo(
      TodoModel todo) async {
    try {
      right(await FirebaseFirestore.instance
          .collection('todoAPP')
          .add(todo.toMap()));
      return right(FirebaseTodoSuccess(success: 'successfully added'));
      // If you want to handle success or notify listeners, you can emit a state from here
    } catch (ex) {
      return left(FirebaseTodoFailure(error: 'Error adding todo: $ex'));
      // Handle the error as needed
    }
  }

  @override
  Future<Either<FirebaseTodoFailure, FirebaseTodoSuccess>> deleteTodoById(
      String id) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('todoAPP')
          .where('id', isEqualTo: id)
          .get();
      id = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('todoAPP').doc(id).delete();
      return right(FirebaseTodoSuccess(success: 'Deleted todo successfully'));
    } catch (ex) {
      return left(FirebaseTodoFailure(error: 'Error getting todo ID: $ex'));
    }
  }

  @override
  Future<Either<FirebaseTodoFailure, FirebaseTodoSuccess>> completeTodoById(
      TodoModel todo) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('todoAPP')
          .where('id', isEqualTo: todo.id)
          .get();

      await FirebaseFirestore.instance
          .collection('todoAPP')
          .doc(querySnapshot.docs.first.id)
          .update({'completed': !todo.completed});

      return right(FirebaseTodoSuccess(success: 'Updated Successfully'));
    } catch (ex) {
      return left(FirebaseTodoFailure(error: 'Update todo error: $ex'));
    }
  }
}
