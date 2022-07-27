import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/view/pokemon_detail_page.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/view/pokemon_detail_view.dart';

import '../../helpers.dart';

void main() {
  group('Pokemon Detail Page', () {
    testWidgets('displays App bar', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            RepositoryProvider<ChopperClient>(
              create: (context) => helperChopperClient,
              child: const PokemonDetailPage(),
            ),
          ),
        );
        expect(find.byType(AppBar), findsOneWidget);
      });
    });
    testWidgets('displays Pokemon Detail view', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          RepositoryProvider<ChopperClient>(
            create: (context) => helperChopperClient,
            child: const PokemonDetailPage(),
          ),
        ),
      );
      expect(find.byType(PokemonDetailView), findsOneWidget);
    });
  });
}
