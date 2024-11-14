import 'package:flutter/widgets.dart';
import 'package:proteine_flutter/utils/live_data/live_data.dart';

class ChangeListener extends StatefulWidget {

  final ChangeNotifier notifier;
  final Widget Function(BuildContext) builder;

  ChangeListener(this.notifier, {required this.builder, Key? key})
      : super(key: key ?? ValueKey(notifier));

  @override
  State createState() => _ChangeListenerState();
}

class _ChangeListenerState extends State<ChangeListener> {

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_onNotified);
  }

  @override
  void didUpdateWidget(ChangeListener oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.notifier.removeListener(_onNotified);
    widget.notifier.addListener(_onNotified);
  }

  void _onNotified() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);

  @override
  void dispose() {
    widget.notifier.removeListener(_onNotified);
    super.dispose();
  }

}

extension LiveDataWidget<T> on LiveData<T> {

  Widget builder(Widget Function(BuildContext, T) builder) {
    return ChangeListener(this, builder: (context) => builder(context, value));
  }

}
