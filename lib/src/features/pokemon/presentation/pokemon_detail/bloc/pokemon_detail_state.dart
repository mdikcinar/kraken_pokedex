part of 'pokemon_detail_bloc.dart';

enum PokemonDetailStatus { initial, fetched, failure }

class PokemonDetailState extends Equatable {
  const PokemonDetailState({this.status = PokemonDetailStatus.initial, this.detail});
  final PokemonDetailStatus status;
  final PokemonDetail? detail;

  PokemonDetailState copyWith({PokemonDetailStatus? status, PokemonDetail? detail}) {
    return PokemonDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [status, detail];
}
