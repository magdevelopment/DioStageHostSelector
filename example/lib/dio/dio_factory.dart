import 'package:dio/dio.dart';
import 'package:dio_stage_host_selector/dio_stage_host_selector.dart';

abstract class DioFactory {
  static const baseUrl = 'https://example.com/';

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 10000,
    sendTimeout: 10000,
  );

  static Dio buildClient() {
    final dio = Dio(_defaultOptions);

    // Should be first
    StageHostSelectorComponent.configureDio(dio);

    return dio;
  }
}
