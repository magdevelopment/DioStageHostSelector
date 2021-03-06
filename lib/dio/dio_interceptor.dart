import 'package:dio/dio.dart';
import 'package:dio_stage_host_selector/repository/stage_repository.dart';

class StageHostSelectorInterceptor extends Interceptor {
  final StageRepository _repository;

  StageHostSelectorInterceptor(this._repository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final customBaseUrl = _repository.selectedUrl;

    if (customBaseUrl != null) {
      options.baseUrl = customBaseUrl;
    }

    return super.onRequest(options, handler);
  }
}
