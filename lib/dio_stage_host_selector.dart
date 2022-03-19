library dio_stage_host_selector;

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio_stage_host_selector/repository/proxy_repository.dart';
import 'package:dio_stage_host_selector/repository/stage_repository.dart';

import 'dio/dio_interceptor.dart';
import 'ui/indicator_widget.dart';

export 'dio/dio_interceptor.dart';

class StageHostSelectorComponent {
  final String _baseUrl;
  final SharedPrefsStageRepository _stageRepository;
  final SharedPrefsProxyRepository _proxyRepository;

  StageHostSelectorComponent._(
    this._baseUrl,
    this._stageRepository,
    this._proxyRepository,
  );

  static late StageHostSelectorComponent _instance;

  static Future<void> init(String defaultUrl) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    _instance = StageHostSelectorComponent._(
      defaultUrl,
      SharedPrefsStageRepository(sharedPreferences),
      SharedPrefsProxyRepository(sharedPreferences),
    );
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

  static void configureDio(Dio dio) {
    dio.interceptors.add(StageHostSelectorComponent.buildInterceptor());

    if (kIsWeb) return; //? Proxy is not awailable for Web adapter

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = StageHostSelectorComponent.findProxy;
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  static String findProxy(Uri uri) {
    final proxy = _instance._proxyRepository.currentValue;
    if (proxy != null) {
      return "PROXY $proxy";
    } else {
      return "DIRECT";
    }
  }
}
