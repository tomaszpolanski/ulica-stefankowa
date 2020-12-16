// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:ulicastefankowa/app.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';

Future<void> main() async {
  final injector = InjectorImpl(
    environment: EnvImpl(),
    routeObservers: [],
  );
  runApp(
    Injection(
      injector,
      child: const MyApp(),
    ),
  );
}
