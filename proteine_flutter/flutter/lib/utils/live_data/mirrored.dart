import 'package:proteine_flutter/utils/live_data/live_data.dart';
import 'package:proteine_flutter/utils/live_data/scope.dart';

class MirroredLiveData<T> extends LiveData<T> {
  final LiveData<T> _base;

  @override
  T get value => _base.value;

  MirroredLiveData({required LiveData<T> base, DataScope? scope})
      : _base = base,
        super(null, scope) {
    base.addListener(_onBaseChanged);
  }

  void _onBaseChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _base.removeListener(_onBaseChanged);
    super.dispose();
  }
}

extension MirroredDataScope on DataScope {
  MirroredLiveData<T> mirror<T>(LiveData<T> base) {
    return MirroredLiveData(base: base, scope: this);
  }
}
