class PathNotFoundException implements Exception {
  PathNotFoundException([this.message = '']);
  final String message;
}

class JsonFactoryNotFoundException implements Exception {
  JsonFactoryNotFoundException([this.message = '']);
  final String message;
}
