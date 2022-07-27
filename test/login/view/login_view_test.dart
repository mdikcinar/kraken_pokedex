import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/cubit/login_cubit.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_page.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class LoginCubitMock extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late AuthRepository authRepository;
  late LoginCubit loginCubit;

  setUp(() {
    authRepository = AuthRepositoryMock();
    loginCubit = LoginCubitMock();
  });

  final loginImageFinder = find.byKey(const Key('login-image'));
  final signInWithFacebookFinder = find.byKey(const Key('sign-in-with-facebook'));
  final signInWithGoogleFinder = find.byKey(const Key('sign-in-with-google'));
  final signInWithAnonymouslyFinder = find.byKey(const Key('sign-in-anonymously'));
  group('Login View', () {
    testWidgets('Find login buttons', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          RepositoryProvider(
            create: (context) => authRepository,
            child: const LoginPage(),
          ),
        ),
      );
      await tester.pump();

      expect(loginImageFinder, findsOneWidget);
      expect(signInWithFacebookFinder, findsOneWidget);
      expect(signInWithGoogleFinder, findsOneWidget);
      expect(signInWithAnonymouslyFinder, findsOneWidget);
    });

    group('Button Taps', () {
      setUp(() {
        when(() => loginCubit.state).thenReturn(LoginInitial());
        when(() => loginCubit.signInWithFacebook()).thenAnswer((_) async {});
        when(() => loginCubit.signInWithGoogle()).thenAnswer((_) async {});
        when(() => loginCubit.signInAnonymously()).thenAnswer((_) async {});
      });

      Widget createWidgetWithMockedCubit() {
        return RepositoryProvider(
          create: (context) => authRepository,
          child: BlocProvider.value(
            value: loginCubit,
            child: const LoginView(),
          ),
        );
      }

      testWidgets('Sign in with Facebook pressed', (tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            createWidgetWithMockedCubit(),
          ),
        );
        await tester.tap(signInWithFacebookFinder);
        verify(() => loginCubit.signInWithFacebook()).called(1);
      });
      testWidgets('Sign in with Google pressed', (tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            createWidgetWithMockedCubit(),
          ),
        );
        await tester.tap(signInWithGoogleFinder);
        verify(() => loginCubit.signInWithGoogle()).called(1);
      });
      testWidgets('Sign in Anonymously pressed', (tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            createWidgetWithMockedCubit(),
          ),
        );
        await tester.tap(signInWithAnonymouslyFinder);
        verify(() => loginCubit.signInAnonymously()).called(1);
      });
      testWidgets('Circular progress showed up', (tester) async {
        when(() => loginCubit.state).thenReturn(LoginSubmitting());
        await tester.pumpWidget(
          createWidgetUnderTest(
            createWidgetWithMockedCubit(),
          ),
        );
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
