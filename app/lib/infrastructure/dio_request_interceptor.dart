import 'package:dio/dio.dart';

class FlutterRequestInterceptorDio implements Interceptor {
  const FlutterRequestInterceptorDio();

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) =>
      handler.next(options);

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) =>
      handler.next(response);

  @override
  void onError(
      DioError err,
      ErrorInterceptorHandler handler,
      ) =>
      handler.next(err);
}