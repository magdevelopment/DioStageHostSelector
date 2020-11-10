library dio_stage_host_selector;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:dio_stage_host_selector/repository/proxy_repository.dart';
import 'package:dio_stage_host_selector/repository/stage_repository.dart';

import 'dio/dio_interceptor.dart';
import 'ui/indicator_widget.dart';

export 'dio/dio_interceptor.dart';

class StageHostSelectorComponent {
  final String _baseUrl;
  final StageRepository _stageRepository;
  final ProxyRepository _proxyRepository;

  StageHostSelectorComponent._(
      this._baseUrl, this._stageRepository, this._proxyRepository);

  static StageHostSelectorComponent _instance;

  static Future<void> init(String baseUrl) async {
    final box = await Hive.openBox('stage_host_selector');
    _instance = StageHostSelectorComponent._(
        baseUrl, StageRepository(box), ProxyRepository(box));
  }

  static Interceptor buildInterceptor() =>
      StageHostSelectorInterceptor(_instance._stageRepository);

  static Widget buildIndicator(BuildContext context) {
    return StageHostIndicatorWidget(
      defaultUrl: _instance._baseUrl,
      stageRepository: _instance._stageRepository,
      proxyRepository: _instance._proxyRepository,
    );
  }

  static String findProxy(Uri uri) {
    final proxy = _instance?._proxyRepository?.selectedProxy;
    if (proxy != null) {
      return "PROXY $proxy";
    } else {
      return "DIRECT";
    }
  }
}
