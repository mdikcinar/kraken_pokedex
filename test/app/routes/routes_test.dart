import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_page.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list_page.dart';
import 'package:kraken_pokedex/src/features/routes/routes.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [PokemonListPage] when authenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.authenticated, []),
        [isA<MaterialPage<dynamic>>().having((p) => p.child, 'child', isA<PokemonListPage>())],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [isA<MaterialPage<dynamic>>().having((p) => p.child, 'child', isA<LoginPage>())],
      );
    });
  });
}
