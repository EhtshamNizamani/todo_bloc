import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/presentation/authentication/sigin_in/sigin_up_screen.dart';
import 'package:todo_bloc/presentation/home/home_screen/home_screen.dart';
import 'package:todo_bloc/presentation/splash/bloc/authentication_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFail) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignUpView()));
          } else if (state is AuthenticationSuccess) {
            print('this state is tigred');

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        },
        builder: (context, state) {
          return const Center(
            child: Text(
              'Your Splash Screen',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }
}
