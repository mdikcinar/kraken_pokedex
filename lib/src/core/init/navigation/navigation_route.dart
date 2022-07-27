import 'package:flutter/material.dart';
import 'package:kraken_pokedex/src/core/init/navigation/app_routes.dart';
import 'package:kraken_pokedex/src/core/widgets/base/route_not_found_page.dart';
import 'package:kraken_pokedex/src/features/pokemon/presentation/pokemon_detail/view/pokemon_detail_page.dart';

class NavigationRoute {
  NavigationRoute._init();

  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  MaterialPageRoute<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.details:
        return normalNavigate(const PokemonDetailPage(), settings);
      default:
        return MaterialPageRoute(
          builder: (context) => RouteNotFoundPage(routeName: settings.name),
        );
    }
  }

  MaterialPageRoute<dynamic> normalNavigate(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings,
    );
  }
}
