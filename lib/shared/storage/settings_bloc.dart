import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';

abstract class SettingsEvent {}

class LoadSettings implements SettingsEvent {
  const LoadSettings();
}

class SaveSettings implements SettingsEvent {
  const SaveSettings(this.settings);

  final Settings settings;
}

class SettingsBloc extends Bloc<SettingsEvent, Settings> {
  SettingsBloc(this.provider) : super(provider.initial);

  final SettingsProvider provider;

  void save(Settings settings) {
    add(SaveSettings(settings));
  }

  void load() => add(const LoadSettings());

  @override
  Stream<Settings> mapEventToState(SettingsEvent event) async* {
    if (event is LoadSettings) {
      final settings = await provider.readSettings();
      yield settings;
    } else if (event is SaveSettings) {
      await provider.saveSettings(event.settings);
      yield event.settings;
    }
  }
}
