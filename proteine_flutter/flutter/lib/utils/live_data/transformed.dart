import 'package:proteine_flutter/utils/live_data/live_data.dart';
import 'package:proteine_flutter/utils/live_data/scope.dart';

class TransformedLiveData<T, D> extends LiveData<T> {
  final LiveData<D> _source;
  final T Function(D) _transform;
  T _value;

  @override
  T get value => _value;

  TransformedLiveData(
      {required LiveData<D> source,
      required T Function(D) transform,
      DataScope? scope})
      : _source = source,
        _transform = transform,
        _value = transform(source.value),
        super(null, scope ?? source.scope) {
    source.addListener(_onSourceChanged);
  }

  void _onSourceChanged() {
    final to = _transform(_source.value);
    if (changeDetector(to, _value)) {
      _value = to;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _source.removeListener(_onSourceChanged);
    super.dispose();
  }
}
