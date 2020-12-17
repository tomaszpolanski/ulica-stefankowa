// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/firebase_analytics.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/observer.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ulicastefankowa/app.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final injector = InjectorImpl(
    environment: EnvImpl(),
    settings: _FakeSettingsProvider(),
    routeObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
  );
  runApp(
    Injection(
      injector,
      child: MyApp(injector),
    ),
  );
}

class _FakeSettingsProvider implements SettingsProvider {
  @override
  Settings get initial => defaultSettings;

  @override
  Future<Settings> readSettings() async => defaultSettings;

  @override
  Future<void> saveSettings(Settings settings) async {}
}
