import 'package:shared_preferences/shared_preferences.dart';

import 'base_repository.dart';

class SharedPrefsStageRepository extends Repository {
  SharedPrefsStageRepository(SharedPreferences sharedPreferences)
      : super(sharedPreferences);

  @override
  String get currentValueKey => 'shs_current_stage';

  @override
  String get suggestedValuesKey => 'shs_suggested_stages';

  @override
  String prepareValue(String value) {
    String preparedValue = value.trim();

    if (preparedValue.isNotEmpty && !preparedValue.endsWith(r'/')) {
      preparedValue = preparedValue + r'/';
    }

    return preparedValue;
  }
}
