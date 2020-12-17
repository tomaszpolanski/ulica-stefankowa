// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ulicastefankowa/main_desktop.dart' as desktop;
import 'package:ulicastefankowa/main_mobile.dart' as mobile;
import 'package:ulicastefankowa/main_web.dart' as web;

Future<void> main() async {
  if (kIsWeb) {
    return web.main();
  } else if (Platform.isAndroid || Platform.isIOS) {
    return mobile.main();
  } else {
    return desktop.main();
  }
}
