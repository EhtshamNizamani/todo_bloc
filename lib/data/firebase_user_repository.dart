import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_bloc/data/user_model.dart';
import 'package:todo_bloc/domain/failures/firebase_todo_failure.dart';
import 'package:todo_bloc/domain/repositories/user_auth_repository.dart';
import 'package:todo_bloc/domain/success/firebase_todo_success.dart';

class FirebaseUserAuthRepository implements UserAuthRepository {
  final fF = FirebaseFirestore.instance.collection('user');
  final FirebaseAuth _firebaseAuth;
  FirebaseUserAuthRepository(FirebaseAuth? firebaseAuth)
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  @override
  Future<Either<Failure, String>> registerUser(
      String email, String password) async {
    try {
      final UserCredential cred = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return right(cred.user!.uid);
    } catch (ex) {
      return left(Failure(error: 'Create user error: $ex'));
    }
  }

  @override
  Future<Either<Failure, Success>> loginUser(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(Success(success: 'Login Successfully'));
    } catch (ex) {
      return left(Failure(error: 'Login: $ex'));
    }
  }

  @override
  Future<Either<Failure, Success>> setUser(UserModel user) async {
    try {
      await fF.doc(user.id).set(user.toMap());
      return right(Success());
    } catch (ex) {
      return left(Failure(error: ex.toString()));
    }
  }

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((User? user) {
      print(user);
      return user;
    });
  }
}
