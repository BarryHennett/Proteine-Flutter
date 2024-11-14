import 'package:flutter/material.dart';
import 'package:proteine_flutter/widget/style/app_colors.dart';
import 'package:proteine_flutter/widget/style/style.dart';

class PhoneLightAppStyle extends _PhoneAppStyle with AppDarkColors {
  PhoneLightAppStyle() : super(ThemeData.light());
}

class PhoneDarkAppStyle extends _PhoneAppStyle with AppDarkColors {
  PhoneDarkAppStyle() : super(ThemeData.dark());
}

abstract class _PhoneAppStyle extends AppStyle {

  _PhoneAppStyle(super.baseTheme);

  @override
  late final double paddingHorizontal = padding16;

  @override
  late final double paddingVertical = padding16;

}