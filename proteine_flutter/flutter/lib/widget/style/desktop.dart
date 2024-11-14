import 'package:flutter/material.dart';
import 'package:proteine_flutter/widget/style/app_colors.dart';
import 'package:proteine_flutter/widget/style/app_measurements.dart';
import 'package:proteine_flutter/widget/style/style.dart';

class DesktopLightAppStyle extends _DesktopAppStyle with AppDarkColors {
  DesktopLightAppStyle() : super(ThemeData.light());
}

class DesktopDarkAppStyle extends _DesktopAppStyle with AppDarkColors {
  DesktopDarkAppStyle() : super(ThemeData.dark());
}

abstract class _DesktopAppStyle extends AppStyle {

  _DesktopAppStyle(super.baseTheme);

  @override
  bool get isLargeScreen => true;

  @override
  double get borderPadding => AppMeasurements.desktopContentPadding;

  @override
  late final double paddingHorizontal = padding24;

  @override
  late final double paddingVertical = padding24;

}