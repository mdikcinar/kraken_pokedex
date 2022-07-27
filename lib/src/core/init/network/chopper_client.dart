import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:kraken_pokedex/src/core/init/network/json_serilizable_converter.dart';
import 'package:kraken_pokedex/src/utils/constants/app_constants.dart';

class ChopperClientBuilder {
  static ChopperClient buildChopperClient(List<ChopperService> services, [http.BaseClient? httpClient]) =>
      ChopperClient(
        client: httpClient,
        baseUrl: AppConstants.baseApiUrl.value,
        services: services,
        converter: JsonSerializableConverter(),
      );
}
