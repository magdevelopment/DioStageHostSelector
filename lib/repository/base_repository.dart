import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Repository {
  final SharedPreferences sharedPreferences;

  late BehaviorSubject<String?> _currentValueSubject;
  late BehaviorSubject<Set<String>> _suggestedValuesSubject;

  Repository(this.sharedPreferences) {
    _currentValueSubject = BehaviorSubject.seeded(currentValue);
    _suggestedValuesSubject = BehaviorSubject.seeded(suggestedValues);
  }

  String get currentValueKey;
  String get suggestedValuesKey;

  String? get currentValue => sharedPreferences.getString(currentValueKey);

  Stream<String?> get currentValueStream => _currentValueSubject.stream;

  Set<String> get suggestedValues =>
      sharedPreferences.getStringList(suggestedValuesKey)?.toSet() ?? {};

  Stream<Set<String>> get suggestedValuesStream =>
      _suggestedValuesSubject.stream;

  void addSuggestedValue(String value) {
    final preparedValue = prepareValue(value);

    if (preparedValue.isEmpty) throw Exception('Value can not be empty');

    final values = _suggestedValuesSubject.value.toSet();
    if (values.add(preparedValue)) {
      _savesuggestedValues(values);

      if (currentValue != preparedValue) {
        setCurrentValue(preparedValue);
      }
    }
  }

  String prepareValue(String value);

  void removeSuggestedValue(String value) {
    final values = _suggestedValuesSubject.value.toSet();
    if (values.remove(value)) {
      _savesuggestedValues(values);

      if (currentValue == value) {
        setCurrentValue(null);
      }
    }
  }

  void _savesuggestedValues(Set<String> values) {
    _suggestedValuesSubject.add(values);
    sharedPreferences.setStringList(suggestedValuesKey, List.from(values));
  }

  void setCurrentValue(String? value) {
    _currentValueSubject.add(value);

    if (value == null) {
      sharedPreferences.remove(currentValueKey);
    } else {
      sharedPreferences.setString(currentValueKey, value);
    }
  }
}
