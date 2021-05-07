# DioStageHostSelector
Tool for using custom stage host in projects with **Dio** with Proxy
Using Hive as persitent storage

![Indicator](/img/indicator_view.png)

![Dialog](/img/dialog.png)

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
      StageHostSelectorComponent.configureDio(dio);
    }
```
