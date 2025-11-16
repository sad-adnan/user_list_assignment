class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException([
    this.message = 'An unknown error occurred',
    this.statusCode,
  ]);
}
