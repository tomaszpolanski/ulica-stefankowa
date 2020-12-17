import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulicastefankowa/features/about/about_page.dart';
import 'package:ulicastefankowa/features/home/home_page.dart';
import 'package:ulicastefankowa/features/not_found/not_found_page.dart';
import 'package:ulicastefankowa/features/post/post_page.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';
import 'package:ulicastefankowa/shared/storage/settings_bloc.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  AppRoutePath currentConfiguration = const MainRoutePath();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, Settings>(
      builder: (context, settings) {
        final configuration = currentConfiguration;
        return Navigator(
          key: navigatorKey,
          pages: [
            MaterialPage(
              key: const ValueKey('main-page'),
              child: HomePage(
                prismic: Injection.of(context)!.prismic,
                onPageChanged: (path) {
                  currentConfiguration = path;
                  notifyListeners();
                },
              ),
            ),
            if (configuration is UnknownRoutePath)
              const MaterialPage(
                key: ValueKey('not-found-page'),
                child: NotFoundPage(),
              )
            else if (configuration is PostRoutePath)
              PostRouterPage(configuration.id)
            else if (configuration is AboutRoutePath)
              const MaterialPage(
                key: ValueKey('about-page'),
                child: AboutPage(),
              )
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            currentConfiguration = const MainRoutePath();
            notifyListeners();
            return true;
          },
        );
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

      if (uri.pathSegments.length == 2) {
        final segment = uri.pathSegments[0];
        if (segment == 'about') {
          return const AboutRoutePath();
        } else if (segment == 'post') {
          final remaining = uri.pathSegments[1];
          // ignore: unnecessary_null_comparison
          return remaining != null
              ? PostRoutePath(remaining)
              : const UnknownRoutePath();
        } else {
          return const UnknownRoutePath();
        }
      }
    }

    return const UnknownRoutePath();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration is UnknownRoutePath) {
      return const RouteInformation(location: '/404');
    } else if (configuration is MainRoutePath) {
      return const RouteInformation(location: '/');
    } else if (configuration is PostRoutePath) {
      return RouteInformation(location: '/post/${configuration.id}');
    } else if (configuration is AboutRoutePath) {
      return const RouteInformation(location: '/about');
    }
    return const RouteInformation(location: '/404');
  }
}

abstract class AppRoutePath {}

class MainRoutePath implements AppRoutePath {
  const MainRoutePath();
}

class AboutRoutePath implements AppRoutePath {
  const AboutRoutePath();
}

class PostRoutePath implements AppRoutePath {
  const PostRoutePath(this.id);

  final String id;
}

class UnknownRoutePath implements AppRoutePath {
  const UnknownRoutePath();
}
