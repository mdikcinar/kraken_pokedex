// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$PokemonApiService extends PokemonApiService {
  _$PokemonApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PokemonApiService;

  @override
  Future<Response<PaginatedData<Pokemon>>> getPokemonList(
      int offset, int? limit) {
    final $url = '/pokemon';
    final $params = <String, dynamic>{'offset': offset, 'limit': limit};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<PaginatedData<Pokemon>, Pokemon>($request);
  }

  @override
  Future<Response<PokemonDetail>> getPokemonDetail({int? id}) {
    final $url = '/pokemon/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<PokemonDetail, PokemonDetail>($request);
  }
}
