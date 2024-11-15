import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proteine_flutter/screen/screen.dart';
import 'package:proteine_flutter/screen/viewmodel.dart';
import 'package:proteine_flutter/widget/style/style.dart';

class ExampleRoute extends GoRoute {
  ExampleRoute(String name, String path)
      : super(
          path: '/quickAddMeal',
          pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: PlaceholderScreen(
                name,
                path,
              )),
        );
}

class PlaceholderScreen extends StatefulWidget {
  final String name;
  final String path;

  PlaceholderScreen(this.name, this.path, {Key? key})
      : super(key: key ?? ValueKey(name));

  @override
  State<StatefulWidget> createState() => _PlaceholderState();
}

class _PlaceholderViewModel extends ViewModel {

}

class _PlaceholderState extends ScreenState<_PlaceholderViewModel, PlaceholderScreen> {

  @override
  final _PlaceholderViewModel viewModel = _PlaceholderViewModel();

  Widget _exampleCell(BuildContext context, AppStyle style, Widget child) =>
      Container(
        width: double.infinity,
        padding: style.contentInsets,
        decoration: style.cellBackground,
        child: child,
      );

  @override
  Widget buildScreen(BuildContext context, AppStyle style) => Container(
    padding: style.contentInsets,
    alignment: Alignment.center,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _exampleCell(context, style, Text(widget.name)),
        SizedBox(
          height: style.paddingVertical,
        ),
        _exampleCell(context, style, Text(widget.path)),
      ],
    ),
  );
}