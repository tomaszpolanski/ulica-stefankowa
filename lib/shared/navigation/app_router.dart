import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ulicastefankowa/features/about/about_page.dart';
import 'package:ulicastefankowa/features/home/home_page.dart';
import 'package:ulicastefankowa/features/not_found/not_found_page.dart';
import 'package:ulicastefankowa/features/post/post_page.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate({this.analytics})
      : navigatorKey = GlobalKey<NavigatorState>();

  final FirebaseAnalytics? analytics;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  AppRoutePath currentConfiguration = const MainRoutePath();

  @override
  Widget build(BuildContext context) {
    final configuration = currentConfiguration;
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey(MainRoutePath()),
          child: HomePage(
            onPageChanged: (path) {
              currentConfiguration = path;
              analytics?.setCurrentScreen(
                screenName: currentConfiguration.toString(),
              );
              notifyListeners();
            },
          ),
        ),
        if (configuration is UnknownRoutePath)
          MaterialPage(
            key: ValueKey(configuration),
            child: const NotFoundPage(),
          )
        else if (configuration is PostRoutePath)
          PostRouterPage(configuration.id)
        else if (configuration is AboutRoutePath)
          const MaterialPage(
            key: ValueKey(AboutRoutePath()),
            child: AboutPage(),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        currentConfiguration = const MainRoutePath();
        analytics?.setCurrentScreen(
          screenName: currentConfiguration.toString(),
        );
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    currentConfiguration = configuration;
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final location = routeInformation.location;
    if (location != null) {
      final uri = Uri.parse(location);
      if (uri.pathSegments.isEmpty) {
        return const MainRoutePath();
      }

      if (uri.pathSegments.length == 1) {
        final segment = uri.pathSegments[0];
        if (segment == 'about') {
          return const AboutRoutePath();
        }
      }

      if (uri.pathSegments.length == 2) {
        final segment = uri.pathSegments[0];
        if (segment == 'post') {
          final remaining = uri.pathSegments[1];
          // ignore: unnecessary_null_comparison
          return remaining != null
              ? PostRoutePath(remaining)
              : const UnknownRoutePath();
        }
      }
    }

    return const UnknownRoutePath();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(location: configuration.toString());
  }
}

abstract class AppRoutePath {}

class MainRoutePath implements AppRoutePath {
  const MainRoutePath();

  @override
  String toString() => '/';
}

class AboutRoutePath implements AppRoutePath {
  const AboutRoutePath();

  @override
  String toString() => '/about';
}

class PostRoutePath implements AppRoutePath {
  const PostRoutePath(this.id);

  final String id;

  @override
  String toString() => '/post/$id';
}

class UnknownRoutePath implements AppRoutePath {
  const UnknownRoutePath();

  @override
  String toString() => '/404';
}

class TrackPageRoute extends MaterialPageRoute<void> {
  TrackPageRoute(String name)
      : super(
          settings: RouteSettings(name: name),
          builder: (_) => const SizedBox(),
        );
}
