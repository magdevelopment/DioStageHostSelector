import 'package:dio/dio.dart';
import 'package:stage_host_selector/repository/stage_repository.dart';

class StageHostSelectorInterceptor extends Interceptor {
  final StageRepository _repository;

  StageHostSelectorInterceptor(this._repository);

  @override
  Future onRequest(RequestOptions options) {
    final customBaseUrl = _repository.selectedUrl;

    if (customBaseUrl != null) {
      options.baseUrl = customBaseUrl;
    }

    return super.onRequest(options);
  }
}
