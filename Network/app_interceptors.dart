part of 'dio_config.dart';

/// An interceptor for [Dio package](https://pub.dev/packages/dio) that implement
/// refresh token for a `DioConfig.dio` instance
class AppInterceptors extends QueuedInterceptorsWrapper {
  final TokenRepository _tokenRepository;
  final Function _logout;
  final AppLogger _logger;

  AppInterceptors(this._tokenRepository, this._logout, this._logger);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    TokenModel? tokens = await _tokenRepository.getTokens();
    if (tokens != null) {
      try {
        final DateTime tokenTime = JwtDecoder.getExpirationDate(tokens.accessToken);
        if (tokenTime.difference(DateTime.now()).inSeconds < 15) {
          tokens = await _tokenRepository.refreshTokens(tokens: tokens);
          await _tokenRepository.saveTokens(tokens: tokens);
        }
      } catch (error, stack) {
        _logger.error('DIO.AppInterceptors error', error, stack);
      }
    }
    handler.next(_setHeaders(options, tokens));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    _logger.error('DIO.AppInterceptors error type = ${err.type}');
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

  RequestOptions _setHeaders(RequestOptions options, TokenModel? token) {
    options.headers['accept'] = 'application/json';

    if (options.method == 'PATCH') {
      options.headers['Content-Type'] = 'application/merge-patch+json';
    }
    if (token != null) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
    return options;
  }

  Future<void> _responseError(Response<dynamic>? response) async {
    if (response != null) {
      final message = '''
        DIO.AppInterceptors response error:
        | code = ${response.statusCode}
        | data: ${response.data}
      ''';
      _logger.error(message);
      if (response.statusCode == NetworkCode.notAuthorized && response.data['message'] == 'Invalid JWT TokenModel') {
        await _logout();
      }
    } else {
      print('DIO UNKNOWN ERROR');
    }
  }
}
