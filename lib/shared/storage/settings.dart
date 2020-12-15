import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SettingsProvider {
  Settings get initial => const Settings(
        version: 1,
        useLightTheme: true,
        textSize: 20,
      );

  Future<File> _getLocalFile() async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/settings.json');
  }

  Future<Settings> readSettings() async {
    try {
      final File file = await _getLocalFile();
      final String contents = await file.readAsString();
      final Map<String, dynamic> settings = json.decode(contents);
      return Settings.fromJson(settings);
    } on FileSystemException {
      return initial;
    }
  }

  Future<void> saveSettings(Settings settings) async {
    await (await _getLocalFile()).writeAsString(json.encode(settings.toJson()));
  }
}

class Settings {
  const Settings({
    required this.version,
    required this.useLightTheme,
    required this.textSize,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      version: json['version'],
      textSize: json['textSize'],
      useLightTheme: json['useLightTheme'],
    );
  }

  final int version;
  final bool useLightTheme;
  final double textSize;

  Settings copyWith({
    final bool? useLightTheme,
    final double? textSize,
  }) {
    return Settings(
      version: version,
      useLightTheme: useLightTheme ?? this.useLightTheme,
      textSize: textSize ?? this.textSize,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'useLightTheme': useLightTheme,
        'textSize': textSize,
      };
}
