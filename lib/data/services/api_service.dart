import 'dart:math';

import 'package:dio/dio.dart';

import '../../core/error/exceptions.dart';
import '../models/pagination_response.dart';
import '../models/user_model.dart';

class ApiService {
  ApiService(this._dio, {Random? random}) : _random = random ?? Random();

  final Dio _dio;
  final Random _random;

  Map<String, dynamic> _buildQueryParameters({
    required int page,
    required int perPage,
  }) {
    final query = {
      'page': page,
      'per_page': perPage,
    };

    if (page > 1) {
      query['delay'] = _random.nextInt(3);
    }

    return query;
  }

  Future<PaginationResponse<User>> getUsers({
    required int page,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/users',
        queryParameters: _buildQueryParameters(page: page, perPage: perPage),
      );

      final data = response.data ?? <String, dynamic>{};
      return PaginationResponse<User>.fromJson(
        data,
        (json) => User.fromJson(json),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        throw ServerException('Please check your internet connection.');
      }

      final responseData = error.response?.data;
      String? message;
      if (responseData is Map<String, dynamic>) {
        final rawError = responseData['error'];
        if (rawError is String) {
          message = rawError;
        }
      } else {
        message = error.message;
      }
      throw ServerException(
        message ?? 'Unable to fetch users',
        error.response?.statusCode,
      );
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
