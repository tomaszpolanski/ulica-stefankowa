import 'dart:async';
import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

const defaultSettings = Settings(
  version: 1,
  useLightTheme: true,
  textSize: 20,
);

abstract class SettingsProvider {
  Settings get initial;

  Future<Settings> readSettings();

  Future<void> saveSettings(Settings settings);
}

class SettingsProviderImpl implements SettingsProvider {
  @override
  Settings get initial => defaultSettings;

  @override
  Future<Settings> readSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('settings')) {
        final contents = prefs.getString('settings');
        final Map<String, dynamic> settings = json.decode(contents);
        return Settings.fromJson(settings);
      }
    } catch (_) {}
    return initial;
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', json.encode(settings.toJson()));
  }
}

class Settings extends Equatable {
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

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [version, useLightTheme, textSize];
}
