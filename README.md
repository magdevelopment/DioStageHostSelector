# DioStageHostSelector
DevTool for define custom stage host url and/or Proxy address in projects with **Dio**
Using [shared_preferences](https://pub.dev/packages/shared_preferences) as persitent storage

![Indicator](/img/indicator_view.png)

![Dialog](/img/dialog.png)

## How to install
```yaml
dependencies:
  dio_stage_host_selector:
    git:
      url: https://github.com/magdevelopment/DioStageHostSelector.git
      ref: 3.0.0
```

## How to use
1. Initialize somewhere in main:
```dart
if (kDevBuild) {
   await StageHostSelectorComponent.init(baseUrl);
}
```

2. Put indicator widget somewhere on login page:
```dart
final widget = StageHostSelectorComponent.buildIndicator(context);
```

3. When creating Dio, configure it by:
```dart
if (kDebugMode) {
    StageHostSelectorComponent.configureDio(dio);
}
```
