import 'package:dio/dio.dart';

import '../repository/base_repository.dart';

class StageHostSelectorInterceptor extends Interceptor {
  final Repository _stageRepository;

  StageHostSelectorInterceptor(this._stageRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final customBaseUrl = _stageRepository.currentValue;

    if (customBaseUrl != null) {
      options.baseUrl = customBaseUrl;
    }

    return super.onRequest(options, handler);
  }
}
