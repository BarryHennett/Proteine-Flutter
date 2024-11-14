


import 'package:flutter/material.dart';
import 'package:proteine_flutter/widget/style/style.dart';

class StyleProvider extends StatelessWidget {
  final Widget Function(BuildContext, AppStyle) _builder;

  const StyleProvider(
      {required Widget Function(BuildContext, AppStyle) builder, super.key})
      : _builder = builder;

  @override
  Widget build(BuildContext context) {
    return _builder(context, context.style);
  }
}

class StylePropagator extends InheritedWidget {
  final AppStyle style;

  const StylePropagator({required this.style, required super.child, super.key});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return (oldWidget as StylePropagator).style != style;
  }
}
