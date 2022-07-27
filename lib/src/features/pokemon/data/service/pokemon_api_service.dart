import 'package:chopper/chopper.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/paginated_data.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon_detail.dart';

part 'pokemon_api_service.chopper.dart';

@ChopperApi()
abstract class PokemonApiService extends ChopperService {
  @Get(path: '/pokemon')
  Future<Response<PaginatedData<Pokemon>>> getPokemonList(
    @Query('offset') int offset,
    @Query('limit') int? limit,
  );

  @Get(path: '/pokemon/{id}')
  Future<Response<PokemonDetail>> getPokemonDetail({@Path('id') int? id});

  static PokemonApiService create([ChopperClient? client]) {
    return _$PokemonApiService(client);
  }
}
