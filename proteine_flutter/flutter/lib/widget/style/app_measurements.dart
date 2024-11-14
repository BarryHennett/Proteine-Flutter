import 'package:flutter/material.dart';

mixin AppMeasurements {
  static const desktopContentWidth = 500.0;
  static const desktopContentPadding = 75.0;
  static const screenSizeThreshold = desktopContentWidth + 2 * desktopContentPadding;

  final double padding4 = 4.0;
  final double padding8 = 8.0;
  final double padding12 = 12.0;
  final double padding16 = 16.0;
  final double padding20 = 20.0;
  final double padding24 = 24.0;
  final double padding52 = 52.0;

  double get constrainedContentWidth => desktopContentWidth;
  double get borderPadding => 0;

  BoxConstraints get smallContentConstraints =>
      BoxConstraints(maxWidth: constrainedContentWidth);

  late final BorderRadius borderRadius = BorderRadius.circular(padding16);

  bool get isLargeScreen => false;

  double get paddingVertical;

  double get paddingHorizontal;

  EdgeInsets get contentInsets => EdgeInsets.symmetric(
      vertical: paddingVertical, horizontal: paddingHorizontal);
}
