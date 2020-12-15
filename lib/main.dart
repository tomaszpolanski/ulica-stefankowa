import 'package:flutter/material.dart';
import 'package:ulicastefankowa/app.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';

void main() {
  final injector = InjectorImpl(environment: EnvImpl());
  runApp(
    Injection(
      injector,
      child: const MyApp(),
    ),
  );
}
