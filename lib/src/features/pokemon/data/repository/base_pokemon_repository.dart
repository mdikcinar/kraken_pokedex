import 'package:kraken_pokedex/src/features/pokemon/data/service/pokemon_api_service.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/customized_pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';

abstract class IPokemonRepository {
  IPokemonRepository({
    required this.pokemonApiService,
  });
  final PokemonApiService pokemonApiService;

  Future<List<CustomizedPokemon>?> fetchPokemonList({required int offset, required int postLimit});
  Future<PokemonDetail?> fetchPokemonDetails({required int pokemonId});
}
