// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ulicastefankowa/app.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final injector = InjectorImpl(
    environment: EnvImpl(),
    routeObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
  );
  runApp(
    Injection(
      injector,
      child: const MyApp(),
    ),
  );
}
