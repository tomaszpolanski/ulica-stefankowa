import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/material/material_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/src/material_localizations.dart';

class CustomLocalizations {
  CustomLocalizations(this.locale);

  final Locale locale;

  static CustomLocalizations of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(context, CustomLocalizations);
  }

  static Map<String, Map<String, String>> _values = {
    'en': {
      'title': 'UliCa SteFAnkOwA',
      'useLightTheme': 'Use Light theme',
      'slowAnimations': 'Slow animations',
      'appVersion': '2017 Beta',
      'appCopy': '© 2017 Tomek & Paweł Polańscy',
      'appDescription': 'TODO Still to do \n',
      'appSourceCode': '.\n\nTo see the source code for this app, please visit the ',
      'appRepoLink': 'Ulica Stefankowa Github repo',
      'postFontSize': "Post's text size",
      'aboutText': """TODO: Moi Drodzy Czytelnicy,

pomysł bloga, na którym umieszczać będę kolejne przygody prosiaczka Stefana, a z czasem również figielki i psoty innych bajkowych bohaterów, powstał z mojej pasji do opisywania świata tak,  jak ja go widzę, a może tak, jak widzieć bym go chciała…. 

Jako że Wy – młodzi czytelnicy – jesteście szczególnie wymagający, to dla Was chciałabym tworzyć i Wasze opinie – mam nadzieję – poznać.

Zapraszam Was serdecznie do lektury zamieszczonych bajeczek, pięknie ilustrowanych przez Paulę Dudek (www.behance.net/paula_dudek).

By nie przegapić żadnych szczegółów z życia prosiaczka, proponuję czytać bajeczki po kolei, od najwcześniejszej""",
      'aboutBlog': 'About',
    },
    'pl': {
      'title': 'UliCa SteFAnkOwA',
      'useLightTheme': 'Użyj jasnego motywu',
      'slowAnimations': 'Powolne animacje',
      'appVersion': '2017 Beta',
      'appCopy': '© 2017 Tomek & Paweł Polańscy',
      'appDescription': 'TODO Do zrobienia \n',
      'appSourceCode': '.\n\nŻeby zobaczyć źródła tej aplikacji, prosze odwiedzić stronę ',
      'appRepoLink': "Ulicy Stefankowej na Github'ie",
      'postFontSize': "Wielkość czcionki artykułu",
      'aboutText': """Moi Drodzy Czytelnicy,

pomysł bloga, na którym umieszczać będę kolejne przygody prosiaczka Stefana, a z czasem również figielki i psoty innych bajkowych bohaterów, powstał z mojej pasji do opisywania świata tak,  jak ja go widzę, a może tak, jak widzieć bym go chciała…. 

Jako że Wy – młodzi czytelnicy – jesteście szczególnie wymagający, to dla Was chciałabym tworzyć i Wasze opinie – mam nadzieję – poznać.

Zapraszam Was serdecznie do lektury zamieszczonych bajeczek, pięknie ilustrowanych przez Paulę Dudek (www.behance.net/paula_dudek).

By nie przegapić żadnych szczegółów z życia prosiaczka, proponuję czytać bajeczki po kolei, od najwcześniejszej""",
      'aboutBlog': 'O Blogu',
    },
  };

  String get title => _values[locale.languageCode]['title'];

  String get useLightTheme => _values[locale.languageCode]['useLightTheme'];

  String get slowAnimations => _values[locale.languageCode]['slowAnimations'];

  String get appVersion => _values[locale.languageCode]['appVersion'];

  String get appCopy => _values[locale.languageCode]['appCopy'];

  String get appDescription => _values[locale.languageCode]['appDescription'];

  String get appSourceCode => _values[locale.languageCode]['appSourceCode'];

  String get appRepoLink => _values[locale.languageCode]['appRepoLink'];

  String get postFontSize => _values[locale.languageCode]['postFontSize'];

  String get aboutText => _values[locale.languageCode]['aboutText'];

  String get aboutBlog => _values[locale.languageCode]['aboutBlog'];

}

class CustomLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pl'].contains(locale.languageCode);

  @override
  Future<CustomLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return new SynchronousFuture<CustomLocalizations>(
        new CustomLocalizations(locale));
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}

class PolishMaterialLocalizations extends GlobalMaterialLocalizations {
  PolishMaterialLocalizations(Locale locale) : super(locale);

  static const LocalizationsDelegate<
      MaterialLocalizations> delegate = const _PolishMaterialLocalizationsDelegate();

  static Future<MaterialLocalizations> load(Locale locale) {
    return new SynchronousFuture<MaterialLocalizations>(
        new PolishMaterialLocalizations(locale));
  }

  @override
  String get openAppDrawerTooltip => 'Otworz nawigację';

  @override
  String get viewLicensesButtonLabel => 'Zobacz licencje';

  @override
  String get closeButtonLabel => 'Zamknij';

  @override
  String aboutListTileTitle(String applicationName) {
    final String text = CustomLocalizations._values['pl']['title'];
    return text.replaceFirst(r'$applicationName', applicationName);
  }

}

class _PolishMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _PolishMaterialLocalizationsDelegate();

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      PolishMaterialLocalizations.load(locale);

  @override
  bool shouldReload(_PolishMaterialLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'pl';

}
