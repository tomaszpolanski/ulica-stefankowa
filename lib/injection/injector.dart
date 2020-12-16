// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import 'package:ulicastefankowa/shared/network/prismic.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';

abstract class Injector {
  Prismic get prismic;

  Env get environment;

  List<RouteObserver<PageRoute<dynamic>>> get routeObservers;
}

class InjectorImpl implements Injector {
  InjectorImpl({
    required this.environment,
    required this.routeObservers,
  }) : prismic = PrismicImpl(environment);

  @override
  final Env environment;

  @override
  final Prismic prismic;

  @override
  final List<RouteObserver<PageRoute<dynamic>>> routeObservers;
}

class Injection extends InheritedWidget implements Injector {
  const Injection(
    Injector injector, {
    required Widget child,
    Key? key,
  })  : _injector = injector,
        super(child: child, key: key);

  final Injector _injector;

  static Injection? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Injection>();

  @override
  Env get environment => _injector.environment;

  @override
  Prismic get prismic => _injector.prismic;

  @override
  List<RouteObserver<PageRoute<dynamic>>> get routeObservers =>
      _injector.routeObservers;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
