import 'package:flutter/material.dart';

abstract class AppFontColors {
  Color get appTextColor;
  Color get appTextSecondary;
}

mixin AppFonts implements AppFontColors {

  TextStyle get systemTextStyle;

  late TextStyle appTextStyle = systemTextStyle.copyWith(
      color: appTextColor,
      fontFamily: "Inter",
      fontWeight: FontWeight.w400,
      height: 1.625,
      fontSize: 12);

  late TextStyleGroup h1 = TextStyleGroup(appTextStyle.copyWith(fontSize: 12, height: 1), appTextColor);
  late TextStyleGroup h3 = TextStyleGroup(appTextStyle.copyWith(fontSize: 18, height: 1), appTextColor);
  late TextStyleGroup body = TextStyleGroup(appTextStyle, appTextColor);
}

class TextStyleGroup {
  final TextStyle regular;
  final TextStyle medium;
  final TextStyle semibold;
  final TextStyle bold;

  TextStyleGroup(TextStyle style, Color textDark)
      : regular = style.copyWith(fontWeight: FontWeight.w400),
        medium = style.copyWith(fontWeight: FontWeight.w500),
        semibold = style.copyWith(fontWeight: FontWeight.w600, color: textDark),
        bold = style.copyWith(fontWeight: FontWeight.w700, color: textDark);
}
