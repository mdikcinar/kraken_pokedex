import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/cubit/login_cubit.dart';
import 'package:mocktail/mocktail.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LoginCubit sut;
  late AuthRepository _authRepository;

  setUp(() {
    _authRepository = AuthRepositoryMock();
    sut = LoginCubit(_authRepository);
  });

  group('Login Cubit', () {
    test(
      'initial status is LoginInitial()',
      () async {
        expect(sut.state, LoginInitial());
      },
    );
    blocTest<LoginCubit, LoginState>(
      'signInWithGoogle error handled',
      setUp: () {
        when(() => _authRepository.signInWithGoogle()).thenThrow(const LogInWithGoogleFailure());
      },
      build: () => sut,
      act: (cubit) => cubit.signInWithGoogle(),
      verify: (_) {
        verify(() => _authRepository.signInWithGoogle()).called(1);
      },
      expect: () => [LoginSubmitting(), const LoginError()],
    );

    blocTest<LoginCubit, LoginState>(
      'successfully signed in with Google',
      setUp: () {
        when(() => _authRepository.signInWithGoogle()).thenAnswer((_) async {});
      },
      build: () => sut,
      act: (cubit) => cubit.signInWithGoogle(),
      verify: (_) {
        verify(() => _authRepository.signInWithGoogle()).called(1);
      },
      expect: () => [LoginSubmitting(), LoginSuccess()],
    );

    blocTest<LoginCubit, LoginState>(
      'signInWithFacebook error handled',
      setUp: () {
        when(() => _authRepository.signInWithFacebook()).thenThrow(const LogInWithFacebookFailure());
      },
      build: () => sut,
      act: (cubit) => cubit.signInWithFacebook(),
      verify: (_) {
        verify(() => _authRepository.signInWithFacebook()).called(1);
      },
      expect: () => [LoginSubmitting(), const LoginError()],
    );

    blocTest<LoginCubit, LoginState>(
      'successfully signed in with Facebook',
      setUp: () {
        when(() => _authRepository.signInWithFacebook()).thenAnswer((_) async {});
      },
      build: () => sut,
      act: (cubit) => cubit.signInWithFacebook(),
      verify: (_) {
        verify(() => _authRepository.signInWithFacebook()).called(1);
      },
      expect: () => [LoginSubmitting(), LoginSuccess()],
    );
    blocTest<LoginCubit, LoginState>(
      'signInAnonymously error handled',
      setUp: () {
        when(() => _authRepository.signInAnonymously()).thenThrow(const LogInAnonymouslyFailure());
      },
      build: () => sut,
      act: (cubit) => cubit.signInAnonymously(),
      verify: (_) {
        verify(() => _authRepository.signInAnonymously()).called(1);
      },
      expect: () => [LoginSubmitting(), const LoginError()],
    );

    blocTest<LoginCubit, LoginState>(
      'successfully signed in Anonymously',
      setUp: () {
        when(() => _authRepository.signInAnonymously()).thenAnswer((_) async {});
      },
      build: () => sut,
      act: (cubit) => cubit.signInAnonymously(),
      verify: (_) {
        verify(() => _authRepository.signInAnonymously()).called(1);
      },
      expect: () => [LoginSubmitting(), LoginSuccess()],
    );
  });
}
