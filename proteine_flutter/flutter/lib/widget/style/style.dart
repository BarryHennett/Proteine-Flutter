import 'package:flutter/material.dart';
import 'package:proteine_flutter/widget/style/app_backgrounds.dart';
import 'package:proteine_flutter/widget/style/app_colors.dart';
import 'package:proteine_flutter/widget/style/app_fonts.dart';
import 'package:proteine_flutter/widget/style/app_measurements.dart';
import 'package:proteine_flutter/widget/style/desktop.dart';
import 'package:proteine_flutter/widget/style/phone.dart';
import 'package:proteine_flutter/widget/style/provider.dart';

class AppStyleVariants {
  final AppStyle light;
  final AppStyle dark;
  AppStyleVariants._internal(this.light, this.dark);

  factory AppStyleVariants.fromScreenWidth(double width) {
    if (width <= AppMeasurements.screenSizeThreshold) {
      return AppStyle.phone;
    } else {
      return AppStyle.desktop;
    }
  }
}

abstract class AppStyle with AppMeasurements, AppColors, AppFonts, AppBackgrounds  {

  static final phone = AppStyleVariants._internal(
      PhoneLightAppStyle(),
      PhoneDarkAppStyle()
  );

  static final desktop = AppStyleVariants._internal(
      DesktopLightAppStyle(),
      DesktopDarkAppStyle()
      );

  AppStyle(this._baseTheme);

  final ThemeData _baseTheme;

  @override
  TextStyle get systemTextStyle => _baseTheme.textTheme.bodyMedium!;

  late final ThemeData theme = _baseTheme.copyWith(
    colorScheme: _baseTheme.colorScheme.copyWith(
      primary: appPrimary,
      surface: appBackground
    ),
    inputDecorationTheme: _baseTheme.inputDecorationTheme.copyWith(
      fillColor: appContentBackground,
    ),
    textTheme: _baseTheme.textTheme.copyWith(
      bodyMedium: body.regular
    )
  );

  static AppStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StylePropagator>()!.style;
  }
}

extension AppStyleContext on BuildContext {
  AppStyle get style => AppStyle.of(this);
}

