import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kraken_pokedex/src/core/extensions/exceptions_extension.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(LoginInitial());
  final AuthRepository _authRepository;

  Future<void> signInWithGoogle() async {
    emit(LoginSubmitting());
    try {
      await _authRepository.signInWithGoogle();
      emit(LoginSuccess());
    } on LogInWithGoogleFailure catch (error) {
      emit(LoginError(message: error.fromCode));
    } catch (_) {
      emit(const LoginError());
    }
  }

  Future<void> signInWithFacebook() async {
    emit(LoginSubmitting());
    try {
      await _authRepository.signInWithFacebook();
      emit(LoginSuccess());
    } on LogInWithGoogleFailure catch (error) {
      emit(LoginError(message: error.fromCode));
    } catch (_) {
      emit(const LoginError());
    }
  }

  Future<void> signInAnonymously() async {
    emit(LoginSubmitting());
    try {
      await _authRepository.signInAnonymously();
      emit(LoginSuccess());
    } on LogInWithGoogleFailure catch (error) {
      emit(LoginError(message: error.fromCode));
    } catch (_) {
      emit(const LoginError());
    }
  }
}
