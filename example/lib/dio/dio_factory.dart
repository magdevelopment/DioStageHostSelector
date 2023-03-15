import 'package:dio/dio.dart';
import 'package:dio_stage_host_selector/dio_stage_host_selector.dart';

abstract class DioFactory {
  static const baseUrl = 'https://example.com/';

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  );

  static Dio buildClient() {
    final dio = Dio(_defaultOptions);

    // Should be first
    StageHostSelectorComponent.configureDio(dio);

    return dio;
  }
}
