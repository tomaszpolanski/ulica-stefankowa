import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ulicastefankowa/features/drawer/main_drawer.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle aboutTextStyle = AppTextTheme.of(context).paragraph;
    final TextStyle linkStyle = AppTextTheme.of(context)
        .medium
        .copyWith(color: Theme.of(context).accentColor);
    return Scaffold(
      appBar: AppBar(
        title: StefanText(
          AppLocalizations.of(context).aboutBlog,
          style: AppTextTheme.of(context).s1,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationIcon: Image.asset(
                  'images/logo.png',
                  height: 100,
                  fit: BoxFit.cover,
                ),
                applicationLegalese: AppLocalizations.of(context).appCopy,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            style: aboutTextStyle,
                            text: AppLocalizations.of(context).appDescription,
                          ),
                          LinkTextSpan(
                            style: linkStyle,
                            url: 'http://ulicastefankowa.pl',
                          ),
                          TextSpan(
                            style: aboutTextStyle,
                            text: AppLocalizations.of(context).appSourceCode,
                          ),
                          LinkTextSpan(
                            style: linkStyle,
                            url: 'https://goo.gl/cYD8Dq',
                            text: AppLocalizations.of(context).appRepoLink,
                          ),
                          TextSpan(style: aboutTextStyle, text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 720,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        style: aboutTextStyle.copyWith(
                            fontStyle: FontStyle.italic),
                        text: AppLocalizations.of(context).aboutText,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/aga.jpg'),
                          ),
                        ),
                      ),
                      Text(
                        'Agnieszka Jakubas',
                        textAlign: TextAlign.left,
                        style: aboutTextStyle.copyWith(
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        'agnieszka.jakubas@ulicastefankowa.pl',
                        textAlign: TextAlign.left,
                        style: aboutTextStyle.copyWith(
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
