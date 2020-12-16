import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ulicastefankowa/features/about/about_page.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key? key,
    required this.title,
    required this.useLightTheme,
    required this.onThemeChanged,
    required this.textScaleFactor,
    required this.onTextScaleFactorChanged,
  }) : super(key: key);

  final String title;

  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double textScaleFactor;
  final ValueChanged<double> onTextScaleFactorChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        primary: false,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: StefanText(
              title,
              style: AppTextTheme.of(context).s1,
            ),
          ),
          const Divider(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).postFontSize,
                textAlign: TextAlign.center,
                style: AppTextTheme.of(context).post.copyWith(
                      fontSize: textScaleFactor,
                    ),
              ),
              Slider(
                value: textScaleFactor,
                min: 10,
                max: 40,
                label: '${textScaleFactor.round()}',
                activeColor: Theme.of(context).accentColor,
                onChanged: onTextScaleFactorChanged,
              ),
            ],
          ),
          const Divider(),
          SwitchListTile(
            title: Text(AppLocalizations.of(context).useLightTheme),
            value: useLightTheme,
            onChanged: onThemeChanged,
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context).aboutBlog),
            onTap: () => Navigator.of(context)?.push(
              MaterialPageRoute<void>(
                builder: (_) => const AboutPage(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  LinkTextSpan({TextStyle? style, required String url, String? text})
      : super(
          style: style,
          text: text ?? url,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(url);
            },
        );
}
