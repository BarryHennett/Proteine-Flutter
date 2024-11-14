
import 'package:proteine_flutter/utils/live_data/live_data.dart';
import 'package:proteine_flutter/utils/live_data/scope.dart';
import 'package:proteine_flutter/utils/live_data/transformed.dart';

extension IterableLiveData<D, L extends Iterable<D>> on LiveData<L> {

  bool get isEmpty => value.isEmpty;
  bool get isNotEmpty => value.isNotEmpty;
  int get length => value.length;

  Iterable<T> map<T>(T Function(D value) toElement) => value.map(toElement);

  void forEach(void Function(D element) action) => value.forEach(action);

  Iterable<T> expand<T>(Iterable<T> Function(D element) toElements) =>
      value.expand(toElements);

  LiveData<Iterable<T>> transformEach<T>(T Function(D item) transform, {DataScope? scope}) {
    return TransformedLiveData(
      source: this,
      transform: (value) => value.map(transform),
      scope: scope,
    );
  }

  LiveData<Iterable<T>> transformEachIndexed<T>(T Function(int index, D item) transform, {DataScope? scope}) {
    return TransformedLiveData(
      source: this,
      transform: (value) {
        final result = List<T>.empty(growable: true);
        for(var index = 0; index < value.length; index++) {
          result.add(transform(index, value.elementAt(index)));
        }
        return result;
      },
      scope: scope,
    );
  }

  LiveData<Iterable<D>> filtered(bool Function(D value) check) => TransformedLiveData(
    source: this,
    transform: (value) => value.where(check),
  );

  LiveData<Iterable<D>> notNull() => TransformedLiveData(
    source: this,
    transform: (value) => value.where((element) => element != null),
  );
}