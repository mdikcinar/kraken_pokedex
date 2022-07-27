import 'package:chopper/chopper.dart';
import 'package:kraken_pokedex/src/core/init/network/json_type_parser.dart';
import 'package:kraken_pokedex/src/core/models/response_error.dart';

class JsonSerializableConverter extends JsonConverter {
  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response<dynamic> response) {
    final jsonRes = super.convertResponse<dynamic, dynamic>(response);
    if (jsonRes.body == null || (jsonRes.body is String && (jsonRes.body as String).isEmpty)) {
      return jsonRes.copyWith(body: null);
    }
    final dynamic body = jsonRes.body;
    final dynamic decodedItem = JsonTypeParser.decode<ResultType>(body);
    return jsonRes.copyWith<ResultType>(body: decodedItem as ResultType);
  }

  @override
  Response<dynamic> convertError<BodyType, InnerType>(Response<dynamic> response) {
    final jsonRes = super.convertError<BodyType, InnerType>(response);
    final dynamic body = jsonRes.body;
    final dynamic responseError = JsonTypeParser.decode<ResponseError>(body);
    return jsonRes.copyWith<BodyType>(bodyError: responseError as BodyType);
  }
}
