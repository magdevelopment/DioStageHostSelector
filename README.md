# StageHostSelector
Tool for using custom stage host in projects with **Dio** with Proxy
Using Hive as persitent storage

## How to include
in pubspec.yaml add:
```yaml
dependencies:
  stage_host_selector:
    git: https://github.com/magdevelopment/DioStageHostSelector.git
```

## How to use
1. Initialize somewhere in main:
```dart
await Hive.initFlutter();

// [!] Should be after Hive
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
    if (kDevBuild) {
      dio.interceptors.add(StageHostSelectorComponent.buildInterceptor());

      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.findProxy = StageHostSelectorComponent.findProxy;
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      };
    }
```
