import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ulicastefankowa/features/home/home_page.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';
import 'package:ulicastefankowa/shared/storage/settings_bloc.dart';

final ThemeData _kGalleryLightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: Colors.white,
);

final ThemeData _kGalleryDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
);

class MyApp extends StatefulWidget {
  const MyApp(this.injector, {Key? key}) : super(key: key);

  final Injector injector;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _settingsInitialized = false;

  @override
  void didChangeDependencies() {
    if (!_settingsInitialized) {
      BlocProvider.of<SettingsBloc>(context).load();
      _settingsInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, Settings>(
      builder: (context, settings) => MaterialApp(
        onGenerateTitle: (c) => AppLocalizations.of(c)!.title,
        navigatorObservers: <NavigatorObserver>[
          ...widget.injector.routeObservers,
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('pl', ''),
        ],
        theme:
            settings.useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme,
        home: HomePage(
          prismic: Injection.of(context)!.prismic,
          useLightTheme: settings.useLightTheme,
          onThemeChanged: (bool value) {},
          fontSize: settings.textSize,
          onFontSizeChanged: (double value) {},
        ),
      ),
    );
  }
}
