import 'package:json_annotation/json_annotation.dart';
import 'package:kraken_pokedex/src/core/models/base_model.dart';
import 'package:kraken_pokedex/src/features/pokemon/domain/models/pokemon.dart';

part 'paginated_data.g.dart';

@JsonSerializable(createToJson: false)
class PaginatedData<T> extends BaseModel<PaginatedData<T>> {
  PaginatedData({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedData.fromJson(Map<String, dynamic> json) => _$PaginatedDataFromJson<T>(json);

  final int? count;
  final String? next;
  final String? previous;
  @_Converter()
  final List<T>? results;

  PaginatedData<R> copyWith<R>({List<R>? results}) {
    return PaginatedData<R>(
      count: count,
      next: next,
      previous: previous,
      results: results,
    );
  }

  @override
  PaginatedData<T> fromJson(Map<String, dynamic> json) {
    return _$PaginatedDataFromJson<T>(json);
  }

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }
}

class _Converter<T> implements JsonConverter<T, Object?> {
  const _Converter();

  @override
  T fromJson(Object? json) {
    if (json is Map<String, dynamic> && json.containsKey('name') && json.containsKey('url')) {
      return Pokemon.fromJson(json) as T;
    }
    return json as T;
  }

  @override
  Object? toJson(T object) => object;
}
