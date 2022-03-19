import 'package:shared_preferences/shared_preferences.dart';

import 'base_repository.dart';

class SharedPrefsProxyRepository extends Repository {
  SharedPrefsProxyRepository(SharedPreferences sharedPreferences)
      : super(sharedPreferences);

  @override
  String get currentValueKey => 'shs_current_proxy';

  @override
  String get suggestedValuesKey => 'shs_suggested_proxies';

  @override
  String prepareValue(String value) {
    return value.trim();
  }
}
