import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proteine_flutter/screen/viewmodel.dart';
import 'package:proteine_flutter/widget/style/provider.dart';
import 'package:proteine_flutter/widget/style/style.dart';

abstract class ScreenState<V extends ViewModel, W extends StatefulWidget> extends State<W> {

  V get viewModel;

  @override
  void initState() {
    super.initState();
    // Core init logic
  }

  @override
  Widget build(BuildContext context) => StyleProvider(builder: (context, style) {
    if(style.isLargeScreen) {
      print("Building desktop");
      return buildDesktopScreen(context, style);
    } else {
      return buildScreen(context, style);
    }
  });

  Widget buildScreen(BuildContext context, AppStyle style);

  //By default we limit the width of the content and center it.
  Widget buildDesktopScreen(BuildContext context, AppStyle style) => Padding(
    padding: EdgeInsets.symmetric(horizontal: style.borderPadding),
    child: Center(
      child: SizedBox(
          width: style.constrainedContentWidth,
          child: buildScreen(context, style)
      ),
    ),
  );

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

}