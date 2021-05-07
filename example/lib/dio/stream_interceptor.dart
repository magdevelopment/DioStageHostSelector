import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class StreamInterceptor extends Interceptor {
  final logsCache = <String>[];
  final logsSubject = BehaviorSubject<List<String>>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logsCache.insert(0, options.uri.toString());
    logsSubject.add(logsCache);
    return handler.reject(
      DioError(
        requestOptions: options,
        error: 'Example do not doing real requests',
      ),
    );
  }

  void close() {
    logsSubject.close();
  }
}
