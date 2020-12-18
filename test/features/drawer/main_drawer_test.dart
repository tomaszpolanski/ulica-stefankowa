// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulicastefankowa/features/drawer/main_drawer.dart';
import 'package:ulicastefankowa/shared/navigation/app_router.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('changing theme', (tester) async {
    var lightTheme = true;
    await tester.pumpPage(
      MainDrawer(
        useLightTheme: lightTheme,
        onThemeChanged: (light) {
          lightTheme = light;
        },
        textScaleFactor: 20,
        onTextScaleFactorChanged: (size) {},
        onPageChanged: (path) {},
      ),
    );

    await tester.tap(find.text(AppLocalizationsEn().useLightTheme));
    await tester.pumpAndSettle();

    expect(lightTheme, isFalse);
  });

  testWidgets('changing font size', (tester) async {
    var fontSize = 20.0;
    await tester.pumpPage(
      MainDrawer(
        useLightTheme: true,
        onThemeChanged: (light) {},
        textScaleFactor: fontSize,
        onTextScaleFactorChanged: (size) {
          fontSize = size;
        },
        onPageChanged: (path) {},
      ),
    );

    await tester.drag(find.byType(Slider), const Offset(1000, 0));
    await tester.pumpAndSettle();

    expect(fontSize, 40.0);
  });

  testWidgets('navigating to about', (tester) async {
    late AppRoutePath page;
    await tester.pumpPage(
      MainDrawer(
        useLightTheme: true,
        onThemeChanged: (light) {},
        textScaleFactor: 20,
        onTextScaleFactorChanged: (size) {},
        onPageChanged: (path) {
          page = path;
        },
      ),
    );

    await tester.tap(find.text(AppLocalizationsEn().aboutBlog));
    await tester.pumpAndSettle();

    expect(page, const AboutRoutePath());
  });
}
