part of 'dio_config.dart';

/// An interceptor for [Dio package](https://pub.dev/packages/dio) that implement
/// refresh token for a `DioConfig.refreshDio` instance
class AppRefreshInterceptors extends QueuedInterceptorsWrapper {
  final AppLogger _logger;
  final Function _logout;

  AppRefreshInterceptors(this._logger, this._logout);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['accept'] = 'application/json';
    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    _logger.error('DIO.AppRefreshInterceptors error ${err.type}');
    switch (err.type) {
      case DioErrorType.connectTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.response:
        await _responseError(err.response);
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        break;
      case DioErrorType.other:
        // TODO: Handle this case.
        break;
    }
    handler.next(err);
  }

  Future<void> _responseError(Response<dynamic>? response) async {
    if (response != null) {
      final message = '''DIO.AppRefreshInterceptors refresh token error '
          | code:  ${response.statusCode}
          | error: ${response.data}
      ''';
      _logger.error(message);
      if (response.statusCode == NetworkCode.notAuthorized && response.data['message'] == 'JWT Refresh Token Not Found') {
        await _logout();
      }
    } else {
      _logger.error('DIO.AppRefreshInterceptors REFRESH DIO UNKNOWN ERROR');
    }
  }
}
