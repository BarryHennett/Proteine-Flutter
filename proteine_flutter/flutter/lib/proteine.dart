import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proteine_flutter/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proteine_flutter/screen/home/addMeal_form.dart';
import 'package:proteine_flutter/screen/home/home_screen.dart';
import 'package:proteine_flutter/widget/style/provider.dart';
import 'package:proteine_flutter/widget/style/style.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
final _rootNavigationKey = GlobalKey<NavigatorState>();

//late final routerAccount = AccountRepository();

AppStyle get style => style;
//LoginSignupViewModel viewModel = LoginSignupViewModel();
//I think these VoidCallBacks cause issues with debugging -Alex
VoidCallback onSignUpSuccess = () {
  print("Sign-up was successful!");
};
VoidCallback onSignUpContinueSuccess = () {
  print("Sign-up was successful!");
};
VoidCallback onLoginSuccess = () {
  print("Sign-up was successful!");
};
VoidCallback onForgotPasswordSuccess = () {
  print("Reset password email sent");
};
VoidCallback onResetPasswordSuccess = () {
  print("Reset password email sent");
};
VoidCallback onInvitePlayerSuccess = () {
  print("Player invite email sent");
};


//Help me with routing please
final router = GoRouter(
    restorationScopeId: "router_restore_scope",
    navigatorKey: _rootNavigationKey,
    initialLocation: "/home",
     redirect: (_, state) {
      print(state.fullPath);
      return state.path; 
    },
    routes: [
      HomeRoute(),
      QuickAddMealRoute(),
    ]);

class ProteineState extends State<Proteine> {
  MaterialApp? _cache;
  AppStyle? _currentStyle;

  AppStyle get style => _currentStyle!;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final variant = AppStyleVariants.fromScreenWidth(screenWidth);
    final style = Theme.of(context).brightness == Brightness.dark
        ? variant.dark
        : variant.light;

    final styleChanged = style != _currentStyle;
    final shouldReRoute = styleChanged && _cache != null;
    if (styleChanged) {
      _currentStyle = style;

      _cache = null;
      print("Style changed to ${style}");
    }

    _cache ??= MaterialApp.router(
      key: const ValueKey("app_root"),
      debugShowCheckedModeBanner: false,
      title: 'Proteine',
      restorationScopeId: "root_restore_scope",
      theme: variant.light.theme,
      darkTheme: variant.dark.theme,
      themeMode: style == variant.light ? ThemeMode.light : ThemeMode.dark,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      routerConfig: router,
    );

    if (shouldReRoute) {
      router.refresh();
    }

    return StylePropagator(
        key: const ValueKey("style_propagator"), style: style, child: _cache!);
  }
}

class Proteine extends StatefulWidget {
  const Proteine() : super(key: const ValueKey("Proteine_root"));

  @override
  State<StatefulWidget> createState() => ProteineState();

  static start(
      {AppConfig? config, required FirebaseOptions firebaseOptions}) async {
    if (config != null) {
      AppConfig.setFlavor(config);
    } else {
      config = AppConfig();
    }
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase (add your Firebase initialization here)
    await Firebase.initializeApp(
      options: firebaseOptions, // Replace with correct options
    );

    // Set Firebase Auth language code (add the language code you want)

    FirebaseAuth.instance.setLanguageCode("en");

    // This removes the "#" from the URL in web.
    usePathUrlStrategy();



    runApp(const Proteine());
  }
}
