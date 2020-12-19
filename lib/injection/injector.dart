// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:ulicastefankowa/shared/network/prismic.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';

abstract class Injector {
  Prismic get prismic;

  Env get environment;

  SettingsProvider get settings;

  FirebaseAnalytics? get analytics;
}

class InjectorImpl implements Injector {
  InjectorImpl({
    required this.environment,
    required this.analytics,
    required this.settings,
  }) : prismic = PrismicImpl(environment);

  @override
  final Env environment;

  @override
  final Prismic prismic;

  @override
  final SettingsProvider settings;

  @override
  final FirebaseAnalytics? analytics;
}

class Injection extends InheritedWidget implements Injector {
  const Injection(
    Injector injector, {
    required Widget child,
    Key? key,
  })  : _injector = injector,
        super(
          child: child,
          key: key,
        );

  final Injector _injector;

  static Injection? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Injection>();

  @override
  Env get environment => _injector.environment;

  @override
  Prismic get prismic => _injector.prismic;

  @override
  FirebaseAnalytics? get analytics => _injector.analytics;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  SettingsProvider get settings => _injector.settings;
}
