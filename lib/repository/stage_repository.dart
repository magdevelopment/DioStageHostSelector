import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

abstract class StageRepository {
  factory StageRepository(Box hiveStorage) => _StageRepositoryImpl(hiveStorage);

  String? get selectedUrl;
  Stream<String> get selectedUrlStream;

  Set<String> get suggestedUrls;
  Stream<Set<String>> get suggestedUrlsStream;

  void addSuggestedUrl(String url);
  void removeSuggestedUrl(String url);
  void selectUrl(String? url);
}

class _StageRepositoryImpl implements StageRepository {
  final Box _hiveBox;

  _StageRepositoryImpl(this._hiveBox);

  static const String _selectedUrlKey = 'selectedUrl';
  static const String _suggestedUrlsKey = 'suggestedUrls';

  @override
  String? get selectedUrl => _hiveBox.get(_selectedUrlKey);

  @override
  Stream<String> get selectedUrlStream {
    return _hiveBox.watch(key: _selectedUrlKey).map((event) {
      if (event.value is String) {
        return event.value as String?;
      } else
        return null;
    }).startWith(selectedUrl) as Stream<String>;
  }

  @override
  Set<String> get suggestedUrls {
    final boxedValue = _hiveBox.get(_suggestedUrlsKey);
    if (boxedValue != null && boxedValue is List<String>) {
      return boxedValue.toSet();
    } else {
      return Set<String>();
    }
  }

  @override
  Stream<Set<String>> get suggestedUrlsStream {
    return _hiveBox.watch(key: _suggestedUrlsKey).map((event) {
      if (event.value != null && event.value is List<String>) {
        return (event.value as List<String>).toSet();
      } else
        return Set<String>();
    }).startWith(suggestedUrls);
  }

  @override
  void addSuggestedUrl(String url) {
    if (url.isEmpty) throw Exception('Url can not be empty');

    final suggestedUrls = this.suggestedUrls;
    suggestedUrls.add(url);
    _saveSuggestedUrls(suggestedUrls);

    if (selectedUrl != url) {
      selectUrl(url);
    }
  }

  @override
  void removeSuggestedUrl(String url) {
    final suggestedUrls = this.suggestedUrls;
    suggestedUrls.remove(url);
    _saveSuggestedUrls(suggestedUrls);

    if (selectedUrl == url) {
      selectUrl(null);
    }
  }

  void _saveSuggestedUrls(Set<String> urls) {
    _hiveBox.put(_suggestedUrlsKey, urls.toList());
  }

  @override
  void selectUrl(String? url) {
    _hiveBox.put(_selectedUrlKey, url);
  }
}
