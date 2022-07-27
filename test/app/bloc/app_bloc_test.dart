import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:mocktail/mocktail.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class UserMock extends Mock implements User {}

void main() {
  final user = UserMock();
  late AuthRepository authRepository;

  setUp(() {
    authRepository = AuthRepositoryMock();
    when(() => authRepository.user).thenAnswer((_) => const Stream.empty());
    when(() => authRepository.currentUser).thenReturn(User.empty);
  });
  group('AppBloc', () {
    test('initial state is unauthenticated when user is empty', () {
      expect(
        AppBloc(authRepository).state,
        const AppState.unauthenticated(),
      );
    });

    group('User Changed', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not empty',
        setUp: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => authRepository.user).thenAnswer((_) => Stream.value(user));
        },
        build: () => AppBloc(authRepository),
        seed: () => const AppState.unauthenticated(),
        expect: () => [AppState.authenticated(user)],
      );
      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is empty',
        setUp: () {
          when(() => user.isNotEmpty).thenReturn(false);
          when(() => authRepository.user).thenAnswer((_) => Stream.value(User.empty));
        },
        build: () => AppBloc(authRepository),
        seed: () => AppState.authenticated(user),
        expect: () => [const AppState.unauthenticated()],
      );
    });
    group('Logout Requested', () {
      blocTest<AppBloc, AppState>(
        'invokes Logout',
        setUp: () {
          when(() => authRepository.logOut()).thenAnswer((_) async {});
        },
        build: () => AppBloc(authRepository),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authRepository.logOut()).called(1);
        },
      );
    });
  });
}
