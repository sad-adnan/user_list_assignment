import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/services/api_service.dart';
import '../../data/services/cache_service.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;
var _isSetup = false;

Future<void> setupLocator() async {
  if (_isSetup) return;
  _isSetup = true;

  sl.registerLazySingleton<Dio>(() => DioClient().createClient());
  sl.registerLazySingleton<ApiService>(() => ApiService(sl()));
  sl.registerLazySingleton<CacheService>(() => CacheService());
  await sl<CacheService>().init();
}
