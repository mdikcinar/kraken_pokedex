import 'package:flutter/widgets.dart';
import 'package:kraken_pokedex/src/core/bloc/app_bloc.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/view/login_page.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_list/view/pokemon_list_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [
        PokemonListPage.page(),
      ];
    case AppStatus.unauthenticated:
      return [
        LoginPage.page(),
      ];
  }
}
