import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Settings {

  num _version = 1;

  bool useLightTheme = true;

  double timeDilation = 1.0;

  double textSize = 20.0;

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/settings.json');
  }

  Future<Null> readSettings() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      Map<String, dynamic> settings = JSON.decode(contents);
      _version = settings['version'];
      useLightTheme = settings['useLightTheme'];
      timeDilation = settings['timeDilation'];
      textSize = settings['textSize'];
    } on FileSystemException {}
  }

  Future<Null> saveSettings() async {
    await (await _getLocalFile()).writeAsString(JSON.encode(_getSettings()));
  }

  Map<String, dynamic> _getSettings() {
    return {
      'useLightTheme': useLightTheme,
      'timeDilation': timeDilation,
      'textSize': textSize,
    };
  }
}

