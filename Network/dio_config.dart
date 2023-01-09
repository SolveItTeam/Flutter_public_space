import 'package:dio/dio.dart';
import 'package:medguard/data/configs/network/jwt_decoder.dart';
import 'package:medguard/data/configs/network/server_config.dart';
import 'package:medguard/data/models/models.dart';
import 'package:medguard/domain/repositories/repositories.dart';
import 'package:medguard/utils/app_logger.dart';

import 'dio_log_interceptors.dart';
part 'app_interceptors.dart';
part 'app_refresh_interceptors.dart';

/// Network response code constants
class NetworkCode {
  NetworkCode._();

  static const success = 200;
  static const notAuthorized = 401;
}

/// Configuration for [Dio](https://pub.dev/packages/dio) instance.
/// * Creates a Dio instance
/// * Connects a refresh token and log interceptors to a Dio instance and handle logout case
class DioConfig {
  static const int timeoutDefault = 10 * 1500;

  late final Dio _dio;
  late final Dio _refreshDio;
  final TokenRepository _tokenRepository;

  Dio get dio => _dio;

  Dio get refreshDio => _refreshDio;

  DioConfig(TokenRepository tokenRepository) : _tokenRepository = tokenRepository {
    _dio = Dio()
      ..options.baseUrl = ServerConfig.baseUrl
      ..options.responseType = ResponseType.json
      ..options.sendTimeout = timeoutDefault
      ..options.receiveTimeout = timeoutDefault
      ..options.connectTimeout = timeoutDefault
      ..interceptors.add(AppInterceptors(tokenRepository, _logout, AppLogger()))
      ..interceptors.add(dioLoggerInterceptor);

    _refreshDio = Dio()
      ..options.baseUrl = ServerConfig.baseUrl
      ..options.responseType = ResponseType.json
      ..options.sendTimeout = timeoutDefault
      ..options.receiveTimeout = timeoutDefault
      ..options.connectTimeout = timeoutDefault
      ..interceptors.add(AppRefreshInterceptors(AppLogger(), _logout))
      ..interceptors.add(dioLoggerInterceptor);
  }

  Future<void> _logout() async {

  }
}
