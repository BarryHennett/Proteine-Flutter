import 'package:proteine_flutter/utils/live_data/live_data.dart';
import 'package:proteine_flutter/utils/live_data/scope.dart';

class MutableLiveData<T> extends LiveData<T> {
  T _value;

  @override
  T get value => _value;

  MutableLiveData(T value, {DataScope? scope, bool emitAllChanges = false})
      : _value = value,
        super(value, scope) {
    if (emitAllChanges) {
      changeDetector = _propagateAllChanges;
    }
  }

  set value(T to) {
    if (changeDetector(to, _value)) {
      _value = to;
      notifyListeners();
    }
  }

  LiveData<T> get immutable => this;

}

bool _propagateAllChanges<T>(T to, T from) => true;