import 'package:flutter/cupertino.dart';
import 'package:proteine_flutter/widget/style/app_colors.dart';
import 'package:proteine_flutter/widget/style/app_measurements.dart';

mixin AppBackgrounds on AppColors, AppMeasurements {

  BoxDecoration cellDecoration(Color color, {Color? shadowColor, bool noShadow = false, BorderRadius? radius}) => BoxDecoration(
      borderRadius: radius ?? borderRadius,
      color: color,
      boxShadow: null);

  BoxDecoration get cellBackground => cellDecoration(appContentBackground);
}