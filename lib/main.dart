import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/subjects.dart';
import 'package:ulicastefankowa/home/HomePage.dart';
import 'package:ulicastefankowa/i18n/Localizations.dart';
import 'package:ulicastefankowa/injection/Injector.dart';
import 'package:ulicastefankowa/network/Prismic.dart';
import 'package:ulicastefankowa/storage/Settings.dart';


final ThemeData _kGalleryLightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: Colors.white,
);

final ThemeData _kGalleryDarkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
);

void main() {
  Injector.bind(prismic: () => new PrismicImpl());
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState(settings: new Settings());
}

class _MyAppState extends State<MyApp> {
  bool _useLightTheme;
  double _timeDilation;
  double _textScaleFactor;
  Timer _timeDilationTimer;

  Settings settings;
  final PublishSubject<Null> _saveSettingsSubject = new PublishSubject();
  StreamSubscription _saveSettingsSubscription;

  _MyAppState({this.settings});


  @override
  void initState() {
    _useLightTheme = settings.useLightTheme;
    timeDilation = _timeDilation = settings.timeDilation;
    _textScaleFactor = settings.textSize;
    readSettings();
    _saveSettingsSubscription = _saveSettingsSubject
        .stream
        .debounce(new Duration(seconds: 1))
        .listen((_) => settings.saveSettings());
    super.initState();
  }

  Future readSettings() async {
    await settings.readSettings();
    setState(() {
      _useLightTheme = settings.useLightTheme;
      timeDilation = _timeDilation = settings.timeDilation;
      _textScaleFactor = settings.textSize;
    });
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    _timeDilationTimer = null;
    _saveSettingsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (context) =>
      CustomLocalizations
          .of(context)
          .title,
      localizationsDelegates: [
        const CustomLocalizationsDelegate(),
        PolishMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('pl', ''),
      ],
      theme: (_useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme),
      home: new HomePage(
        prismic: new Injector().prismic,
        useLightTheme: _useLightTheme,
        onThemeChanged: (bool value) {
          setState(() {
            _useLightTheme = settings.useLightTheme = value;
          });
          _saveSettingsSubject.add(null);
        },
        timeDilation: _timeDilation,
        onTimeDilationChanged: (double value) {
          setState(() {
            _timeDilationTimer?.cancel();
            _timeDilationTimer = null;
            _timeDilation = settings.timeDilation = value;
            if (_timeDilation > 1.0) {
              // We delay the time dilation change long enough that the user can see
              // that the checkbox in the drawer has started reacting, then we slam
              // on the brakes so that they see that the time is in fact now dilated.
              _timeDilationTimer =
              new Timer(const Duration(milliseconds: 150), () {
                timeDilation = _timeDilation;
              });
            } else {
              timeDilation = _timeDilation;
            }
          });
          _saveSettingsSubject.add(null);
        },
        fontSize: _textScaleFactor,
        onFontSizeChanged: (double value) {
          setState(() {
            _textScaleFactor = settings.textSize = value;
          });

          _saveSettingsSubject.add(null);
        },
      ),
    );
  }
}
