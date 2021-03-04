import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

abstract class ProxyRepository {
  factory ProxyRepository(Box hiveStorage) => _ProxyRepositoryImpl(hiveStorage);

  String? get selectedProxy;
  Stream<String> get selectedProxyStream;

  Set<String> get suggestedProxys;
  Stream<Set<String>> get suggestedProxysStream;

  void addSuggestedProxy(String proxy);
  void removeSuggestedProxy(String proxy);
  void selectProxy(String? proxy);
}

class _ProxyRepositoryImpl implements ProxyRepository {
  final Box _hiveBox;

  _ProxyRepositoryImpl(this._hiveBox);

  static const String _selectedProxyKey = 'selectedProxy';
  static const String _suggestedProxysKey = 'suggestedProxys';

  @override
  String? get selectedProxy => _hiveBox.get(_selectedProxyKey);

  @override
  Stream<String> get selectedProxyStream {
    return _hiveBox.watch(key: _selectedProxyKey).map((event) {
      if (event.value is String) {
        return event.value as String?;
      } else
        return null;
    }).startWith(selectedProxy) as Stream<String>;
  }

  @override
  Set<String> get suggestedProxys {
    final boxedValue = _hiveBox.get(_suggestedProxysKey);
    if (boxedValue != null && boxedValue is List<String>) {
      return boxedValue.toSet();
    } else {
      return Set<String>();
    }
  }

  @override
  Stream<Set<String>> get suggestedProxysStream {
    return _hiveBox.watch(key: _suggestedProxysKey).map((event) {
      if (event.value != null && event.value is List<String>) {
        return (event.value as List<String>).toSet();
      } else
        return Set<String>();
    }).startWith(suggestedProxys);
  }

  @override
  void addSuggestedProxy(String proxy) {
    if (proxy.isEmpty) throw Exception('Proxy can not be empty');

    final suggestedProxys = this.suggestedProxys;
    suggestedProxys.add(proxy);
    _savesuggestedProxys(suggestedProxys);

    if (selectedProxy != proxy) {
      selectProxy(proxy);
    }
  }

  @override
  void removeSuggestedProxy(String proxy) {
    final suggestedProxys = this.suggestedProxys;
    suggestedProxys.remove(proxy);
    _savesuggestedProxys(suggestedProxys);

    if (selectedProxy == proxy) {
      selectProxy(null);
    }
  }

  void _savesuggestedProxys(Set<String> proxys) {
    _hiveBox.put(_suggestedProxysKey, proxys.toList());
  }

  @override
  void selectProxy(String? proxy) {
    _hiveBox.put(_selectedProxyKey, proxy);
  }
}
