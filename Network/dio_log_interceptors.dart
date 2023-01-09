import 'package:dio/dio.dart';
import 'package:medguard/utils/app_logger.dart';

/// [Dio package](https://pub.dev/packages/dio) interceptor wrapper for log network request/response/error events.
/// __How to use__:
/// `Dio()..interceptors.add(dioLoggerInterceptor);`
final dioLoggerInterceptor = InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
  String headers = "";
  options.headers.forEach((key, value) {
    headers += "| $key: $value";
  });
  AppLogger().debug('''NETWORK REQUEST: ${options.method} ${options.uri}
    | ${options.data.toString()}
    | Headers:\n$headers'''
  );
  handler.next(options);
}, onResponse: (Response response, handler) async {
  AppLogger().debug('''NETWORK RESPONSE [code ${response.statusCode}]: ${response.data.toString()}''');
  handler.next(response);
}, onError: (DioError error, handler) async {
  AppLogger().error('''NETWORK ERROR: ${error.error}: ${error.response?.toString()}''');
  handler.next(error);
});