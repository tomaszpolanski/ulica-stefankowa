// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:ulicastefankowa/app.dart';
import 'package:ulicastefankowa/injection/blocs.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';

Future<void> main() async {
  final injector = InjectorImpl(
    environment: EnvImpl(),
    analytics: null,
    settings: SettingsProviderImpl(),
  );
  runApp(
    Injection(
      injector,
      child: BlockInjection(injector, child: MyApp(injector)),
    ),
  );
}
