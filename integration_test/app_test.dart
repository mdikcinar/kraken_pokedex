// ignore_for_file: omit_local_variable_types, cascade_invocations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kraken_pokedex/main.dart' as app;
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_page.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/view/pokemon_detail_page.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('end-to-end test', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final signInWithGoogleFinder = find.byKey(const Key('sign-in-with-google'));
    final signInWithAnonymouslyFinder = find.byKey(const Key('sign-in-anonymously'));
    final logoutButtonFinder = find.byKey(const Key('logout-button'));

    //sign out if already signed in
    await runZonedGuarded(
      () async {
        expect(signInWithAnonymouslyFinder, findsOneWidget);
      },
      (error, stack) async {
        await tester.tap(logoutButtonFinder);
        await tester.pumpAndSettle();
      },
    );

    //test sign in anonymously
    await tester.tap(signInWithAnonymouslyFinder);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(PokemonListPage), findsOneWidget);
    await tester.tap(logoutButtonFinder);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(PokemonListPage), findsNothing);

    //test sign in with google
    await tester.tap(signInWithGoogleFinder);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(PokemonListPage), findsOneWidget);

    //navigate to detail page
    final firstPokemonFinder = find.byKey(const Key('pokemonCard1'));
    await tester.tap(firstPokemonFinder);
    await tester.pumpAndSettle();
    expect(find.byType(PokemonListPage), findsNothing);
    expect(find.byType(PokemonDetailPage), findsOneWidget);

    //open abilities tab
    final abilitiesTextFinder = find.byKey(const Key('abilitiesText'));
    await tester.tap(abilitiesTextFinder);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('abilitiesTab')), findsOneWidget);

    //open moves tab
    final movesTextFinder = find.byKey(const Key('movesText'));
    await tester.tap(movesTextFinder);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('movesTab')), findsOneWidget);

    //back to pokemon list
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.byType(PokemonDetailPage), findsNothing);
    expect(find.byType(PokemonListPage), findsOneWidget);

    //logout
    await tester.tap(logoutButtonFinder);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(PokemonListPage), findsNothing);
  });
}
