# DioStageHostSelector
Tool for using custom stage host in projects with **Dio** with Proxy
Using Hive as persitent storage

## How to install
```yaml
dependencies:
  dio_stage_host_selector:
    git:
      url: https://github.com/magdevelopment/DioStageHostSelector.git
      ref: 1.0.0
```

## How to use
1. Initialize somewhere in main:
```dart
await Hive.initFlutter();

if (kDevBuild) {
   await StageHostSelectorComponent.init(baseUrl);
}
```

2. Put indicator widget somewhere on login page:
```dart
    final widget = StageHostSelectorComponent.buildIndicator(context);
```

3. When creating Dio add interceptor and proxy handler:
```dart
    if (kDebugMode) {
      dio.interceptors.add(StageHostSelectorComponent.buildInterceptor());

      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.findProxy = StageHostSelectorComponent.findProxy;
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      };
    }
```
