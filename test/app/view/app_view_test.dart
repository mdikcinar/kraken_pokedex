import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:chopper/chopper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/app.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_page.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers.dart';
import '../bloc/app_state_test.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class UserMock extends Mock implements User {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

Widget createAppViewWidgetWithMockedBloc({
  required AuthRepository authRepository,
  required AppBloc appBloc,
  required Widget child,
}) {
  return RepositoryProvider<AuthRepository>.value(
    value: authRepository,
    child: MaterialApp(
      home: BlocProvider<AppBloc>.value(
        value: appBloc,
        child: createLocalizedWidgetForTesting(child: child),
      ),
    ),
  );
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  late AuthRepository authRepository;
  late AppBloc appBloc;
  late User user;

  setUp(() {
    authRepository = AuthRepositoryMock();
    user = UserMock();
    appBloc = MockAppBloc();
  });

  group('App', () {
    testWidgets('localized AppView rendered', (tester) async {
      await tester.runAsync(() async {
        when(() => authRepository.user).thenAnswer((_) => const Stream.empty());
        when(() => authRepository.currentUser).thenReturn(user);
        when(() => user.isNotEmpty).thenReturn(true);
        when(() => user.isEmpty).thenReturn(false);

        await tester.pumpWidget(
          createLocalizedWidgetForTesting(
            child: App(authRepository, helperChopperClient),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AppView), findsOneWidget);
      });
    });
  });

  group('AppView', () {
    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      await tester.runAsync(() async {
        when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
        await tester.pumpWidget(
          createAppViewWidgetWithMockedBloc(
            authRepository: authRepository,
            appBloc: appBloc,
            child: const AppView(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(LoginPage), findsOneWidget);
      });
    });
    testWidgets('navigates to PokemonListPage when authenticated', (tester) async {
      await tester.runAsync(() async {
        final user = MockUser();
        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
        await tester.pumpWidget(
          RepositoryProvider<ChopperClient>(
            create: (context) => helperChopperClient,
            child: createAppViewWidgetWithMockedBloc(
              authRepository: authRepository,
              appBloc: appBloc,
              child: const AppView(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PokemonListPage), findsOneWidget);
      });
    });
  });
}
