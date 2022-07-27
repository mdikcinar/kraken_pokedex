part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSubmitting extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  const LoginError({this.message});
  final String? message;
}
