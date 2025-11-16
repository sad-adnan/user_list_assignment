import 'package:dio/dio.dart';

import '../config/app_constants.dart';

class DioClient {
  Dio createClient() {
    final options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'x-api-key': AppConstants.apiKey,
        'Content-Type': 'application/json',
      },
    );

    final dio = Dio(options);
    return dio;
  }
}
