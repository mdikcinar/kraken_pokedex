enum AppConstants {
  baseApiUrl,
  localizationsPath,
  facebookIcon,
  googleIcon,
  pokemonImagesPath,
  pokedexIcon;

  String get value {
    switch (this) {
      case AppConstants.baseApiUrl:
        return 'https://pokeapi.co/api/v2';
      case AppConstants.localizationsPath:
        return 'assets/languages';
      case AppConstants.pokedexIcon:
        return 'assets/images/pokedex-icon.jpg';
      case AppConstants.facebookIcon:
        return 'assets/svg/facebook-icon.svg';
      case AppConstants.googleIcon:
        return 'assets/svg/google-icon.svg';
      case AppConstants.pokemonImagesPath:
        return 'assets/images/pokemon';
    }
  }
}
