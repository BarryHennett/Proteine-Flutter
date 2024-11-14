import 'package:flutter/foundation.dart';
import 'package:proteine_flutter/utils/live_data/mutable.dart';

class DataScope {

  final List<ChangeNotifier> _items = List.empty(growable: true);
  final List<DataScope> _children = List.empty(growable: true);
  final DataScope? parent;

  DataScope({this.parent}) {
    parent?._children.add(this);
  }

  T add<T extends ChangeNotifier>(T data) {
    if(!_items.contains(data)) {
      _items.add(data);
    }
    return data;
  }

  bool remove(ChangeNotifier data) {
    if(_items.contains(data)) {
      _items.remove(data);
      return true;
    } else {
      return false;
    }
  }

  void clean(ChangeNotifier data) {
    if(remove(data)) {
      data.dispose();
    }
  }

  void cleanScope() {
    for (var child in _children.reversed.toList()) {
      child.dispose();
    }

    for(var item in _items.reversed.toList()) {
      clean(item);
    }

    parent?._children.remove(this);
  }

  void dispose() {
    cleanScope();
  }

  DataScope child() => DataScope(parent: this);

  MutableLiveData<T> mutable<T>(T start) => add(MutableLiveData(start));

}