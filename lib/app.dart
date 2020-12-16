import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';
import 'package:ulicastefankowa/features/home/home_page.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';

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
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Settings _settings;

  final SettingsProvider settings = SettingsProvider();
  final PublishSubject<Settings> _saveSettingsSubject = PublishSubject();
  late StreamSubscription<Settings> _saveSettingsSubscription;

  @override
  void initState() {
    _settings = settings.initial;
    readSettings();
    _saveSettingsSubscription = _saveSettingsSubject.stream
        .debounce((_) => TimerStream(true, const Duration(seconds: 1)))
        .listen(settings.saveSettings);
    super.initState();
  }

  Future<void> readSettings() async {
    final s = await settings.readSettings();
    setState(() {
      _settings = s;
    });
  }

  @override
  void dispose() {
    _saveSettingsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (c) => AppLocalizations.of(c).title,
      navigatorObservers: <NavigatorObserver>[
        ...?Injection.of(context)?.routeObservers,
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
      theme: _settings.useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme,
      home: HomePage(
        prismic: Injection.of(context)!.prismic,
        useLightTheme: _settings.useLightTheme,
        onThemeChanged: (bool value) {
          setState(() {
            _settings = _settings.copyWith(useLightTheme: value);
          });
          _saveSettingsSubject.add(_settings);
        },
        fontSize: _settings.textSize,
        onFontSizeChanged: (double value) {
          setState(() {
            _settings = _settings.copyWith(textSize: value);
          });

          _saveSettingsSubject.add(_settings);
        },
      ),
    );
  }
}
