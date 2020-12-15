import 'package:flutter/cupertino.dart';
import 'package:ulicastefankowa/shared/network/prismic.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';

abstract class Injector {
  Prismic get prismic;

  Env get environment;
}

class InjectorImpl implements Injector {
  InjectorImpl({required this.environment})
      :  prismic = PrismicImpl(environment);

  @override
  final Env environment;

  @override
  final Prismic prismic;
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
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
