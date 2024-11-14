import 'dart:ui';
import 'package:proteine_flutter/widget/style/app_fonts.dart';

abstract mixin class AppColors implements AppFontColors {
  final Color appWhite = const Color(0xFFFFFFFF);
  final Color appBlack = const Color(0xFF000000);

  final Color appBlueDark = const Color(0xFF16161D);
  final Color appBlueMid = const Color(0xFF181928);
  final Color appBlueLight = const Color(0xFF242539);
  final Color appBlueLink = const Color(0xFF5987F7);
  final Color itemBlue = const Color(0xFF222232);

  final Color appRedMid = const Color(0xFFFF0606);
  final Color appRedLight = const Color(0xFFE91E63);
  final Color appPinkLight = const Color(0xFFFF4081);

  final Color appOrangeLight = const Color(0xFFFF9E0D);

  final Color appGreenLight = const Color(0xFF4DFF89);
  final Color appGreenMid = const Color(0xFF4CAF50);

  final Color appPurple = const Color(0xFF9C27B0);
  
  final Color appGrey050 = const Color(0xFFAAAAAF);
  final Color appGrey400 = const Color(0xFFC4C4C4);

  Color get appPrimary;

  Color get appBackground;
  Color get appBackgroundMid;
  Color get appContentBackground;
}

//We only really have a dark mode at the moment, but we could clone this for light mode.
mixin AppDarkColors on AppColors {
  @override
  Color get appPrimary => appGreenLight;

  @override
  Color get appTextColor => appWhite;
  @override
  Color get appTextSecondary => appGrey050;

  @override
  Color get appBackground => appBlueDark;
  @override
  Color get appBackgroundMid => appBlueMid;
  @override
  Color get appContentBackground => appBlueLight;
}
