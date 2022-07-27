import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/cubit/login_cubit.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<dynamic> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(context.read<AuthRepository>()),
      child: const LoginView(),
    );
  }
}
