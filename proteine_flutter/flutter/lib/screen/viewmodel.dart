

import 'package:proteine_flutter/utils/live_data/scope.dart';

abstract class ViewModel {

  late final DataScope scope = DataScope();

  void dispose() {
    scope.dispose();
  }

}