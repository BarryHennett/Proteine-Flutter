import 'package:flutter/foundation.dart';
import 'package:proteine_flutter/utils/live_data/mirrored.dart';
import 'package:proteine_flutter/utils/live_data/scope.dart';
import 'package:proteine_flutter/utils/live_data/transformed.dart';

abstract class LiveData<T> extends ChangeNotifier {
  final DataScope? parentScope;
  final DataScope? scope;

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  final List<Function(T)> _subscribers = [];

  T get value;

  T? _lastNotifyCheck;

  LiveData([T? value, DataScope? scope])
      : parentScope = scope,
        scope = scope?.child() {
    _lastNotifyCheck = value;
    scope?.add(this);
  }

  T call() => value;

  late bool Function(T, T) changeDetector = _propagateObjectChanges;

  LiveData<T> subscribe(Function(T value) callback) {
    if (!_subscribers.contains(callback)) {
      _subscribers.add(callback);
      callback(value);
    }
    return this;
  }

  void reload() {
    notifyListeners();
  }

  void unsubscribe(Function(T value) callback) {
    _subscribers.remove(callback);
  }

  void notifyIfChanged() {
    final from = _lastNotifyCheck;
    if (from != null) {
      if (changeDetector(value, from)) {
        _lastNotifyCheck = value;
        notifyListeners();
      }
    } else {
      _lastNotifyCheck = value;
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();

    final value = this.value;
    for (var callback in _subscribers) {
      callback(value);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscribers.clear();
    scope?.dispose();
    parentScope?.remove(this);
    super.dispose();
  }

  LiveData<D> transform<D>(D Function(T) transform, {DataScope? scope}) => TransformedLiveData(source: this, transform: transform, scope: scope);

  LiveData<T> mirror(DataScope? scope) => MirroredLiveData(base: this, scope: scope);
}

bool _propagateObjectChanges<T>(T to, T from) {
  if (to is List && from is List) {
    if (to.length != from.length) return true;

    for (var i = 0; i < to.length; i++) {
      if (to[i] != from[i]) {
        return true;
      }
    }
  }

  if (to is Map && from is Map) {
    if (to.length != from.length) return true;

    for (var key in to.keys) {
      if (!from.containsKey(key) || from[key] != to[key]) {
        return true;
      }
    }
  }

  if (to is Iterable && from is Iterable) {
    final toItr = to.toList();
    final fromItr = from.toList();
    if (toItr.length != fromItr.length) return true;
    for (var i = 0; i < toItr.length; i++) {
      if (toItr[i] != fromItr[i]) {
        return true;
      }
    }
  }

  return to != from;
}