import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_bloc/data/firebase_todo_repository.dart';
import 'package:todo_bloc/data/firebase_user_repository.dart';
import 'package:todo_bloc/data/todo_model.dart';
import 'package:todo_bloc/domain/repositories/firebase_repository.dart';
import 'package:todo_bloc/domain/repositories/user_auth_repository.dart';
import 'package:todo_bloc/presentation/authentication/sigin_in/bloc/login_bloc.dart';
import 'package:todo_bloc/presentation/authentication/sigin_in/sigin_up_screen.dart';
import 'package:todo_bloc/presentation/authentication/sigin_up/bloc/register_bloc.dart';
import 'package:todo_bloc/presentation/authentication/sigin_up/register_view.dart';
import 'package:todo_bloc/presentation/home/bloc/todo_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_bloc/presentation/splash/bloc/authentication_bloc.dart';
import 'package:todo_bloc/presentation/splash/splash_view/splash_screen.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  getIt.registerSingleton<FirebaseRepository>(FirebaseTodoRepository());

  getIt.registerSingleton<UserAuthRepository>(
      FirebaseUserAuthRepository(getIt()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(getIt()),
        ),
        BlocProvider(
          create: (context) => TodoBloc(getIt())..add(GetAllTodo()),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(getIt()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(getIt()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
