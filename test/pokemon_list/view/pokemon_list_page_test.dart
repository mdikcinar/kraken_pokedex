import 'package:bloc_test/bloc_test.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

extension on WidgetTester {
  Future<void> pumpPokemonPage(AppBloc bloc) async {
    return pumpWidget(
      BlocProvider<AppBloc>(
        create: (context) => bloc,
        child: createWidgetUnderTest(
          RepositoryProvider<ChopperClient>(
            create: (context) => helperChopperClient,
            child: const PokemonListPage(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late AppBloc appBloc;

  setUp(() {
    appBloc = MockAppBloc();
  });
  group('Pokemon List Page', () {
    testWidgets('displays App bar and App name', (tester) async {
      await tester.runAsync(() async {
        when(() => appBloc.add(AppLogoutRequested())).thenAnswer((_) async {});
        await tester.pumpPokemonPage(appBloc);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byKey(const Key('appNameText')), findsOneWidget);
      });
    });
    testWidgets('displays Pokemon List', (tester) async {
      await tester.runAsync(() async {
        when(() => appBloc.add(AppLogoutRequested())).thenAnswer((_) async {});
        await tester.pumpPokemonPage(appBloc);
        expect(find.byType(PokemonList), findsOneWidget);
      });
    });
    testWidgets('displays logout button, logout button triggers logout', (tester) async {
      await tester.runAsync(() async {
        when(() => appBloc.add(AppLogoutRequested())).thenAnswer((_) async {});
        await tester.pumpPokemonPage(appBloc);
        final logoutButton = find.byKey(const Key('logout-button'));
        expect(logoutButton, findsOneWidget);
        await tester.tap(logoutButton);
        verify(() => appBloc.add(AppLogoutRequested())).called(1);
      });
    });
  });
}
