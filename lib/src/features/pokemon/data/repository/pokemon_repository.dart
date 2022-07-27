import 'package:flutter/material.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/repository/base_pokemon_repository.dart';
import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';
import 'package:kraken_pokedex/src/utils/constants/app_constants.dart';
import 'package:palette_generator/palette_generator.dart';

class PokemonRepository extends IPokemonRepository {
  factory PokemonRepository(PokemonApiService pokemonApiService) {
    _shared ??= PokemonRepository._sharedInstance(pokemonApiService: pokemonApiService);
    return _shared!;
  }
  PokemonRepository._sharedInstance({required super.pokemonApiService});
  static PokemonRepository? _shared;

  @override
  Future<List<CustomizedPokemon>?> fetchPokemonList({
    required int offset,
    required int postLimit,
  }) async {
    final result = await pokemonApiService.getPokemonList(offset, postLimit);
    final pokemonList = result.body?.results;
    if (pokemonList == null) return null;
    final customizedPokemonList = await Future.wait(
      pokemonList.map(
        (pokemon) async {
          final pokemonId = getIdFromUrl(pokemon.url);
          final backgroundColor = await generateBackgroundColors(pokemonId);
          return CustomizedPokemon(
            pokemon: pokemon,
            id: pokemonId,
            backgroundColor: backgroundColor,
          );
        },
      ).toList(),
    );
    return customizedPokemonList;
  }

  int? getIdFromUrl(String? url) {
    if (url == null) return null;
    final baseUrl = '${AppConstants.baseApiUrl.value}/pokemon/';
    var id = url.replaceAll(baseUrl, '');
    id = id.replaceAll(RegExp('[^0-9]'), '');

    return int.tryParse(id);
  }

  Future<String?> generateBackgroundColors(int? pokemonId) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.asset('${AppConstants.pokemonImagesPath.value}/$pokemonId.png').image,
    );
    final dominantColor = paletteGenerator.dominantColor?.color;
    final color = dominantColor != null ? HSLColor.fromColor(dominantColor).withLightness(0.9).toColor() : null;
    return color?.value.toString();
  }

  @override
  Future<PokemonDetail?> fetchPokemonDetails({required int pokemonId}) async {
    final result = await pokemonApiService.getPokemonDetail(id: pokemonId);
    return result.body;
  }
}
