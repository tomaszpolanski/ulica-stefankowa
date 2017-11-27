import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ulicastefankowa/MainDrawer.dart';
import 'package:ulicastefankowa/i18n/Localizations.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

class AboutPage extends StatelessWidget {
  AboutPage({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(
        color: themeData.accentColor);
    return new Scaffold(
      appBar: new AppBar(
        title: buildThemedText(title, Theme
            .of(context)
            .textTheme
            .title,
            Theme
                .of(context)
                .brightness),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Info',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationVersion: CustomLocalizations
                    .of(context)
                    .appVersion,
                applicationIcon: new Image.asset(
                    'images/logo.png',
                    height: 100.0,
                    fit: BoxFit.cover),
                applicationLegalese: CustomLocalizations
                    .of(context)
                    .appCopy,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: new RichText(
                      text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                            style: aboutTextStyle,
                            text: CustomLocalizations
                                .of(context)
                                .appDescription,
                          ),
                          new LinkTextSpan(
                              style: linkStyle,
                              url: 'http://ulicastefankowa.pl'
                          ),
                          new TextSpan(
                              style: aboutTextStyle,
                              text: CustomLocalizations
                                  .of(context)
                                  .appSourceCode
                          ),
                          new LinkTextSpan(
                              style: linkStyle,
                              url: 'https://goo.gl/cYD8Dq',
                              text: CustomLocalizations
                                  .of(context)
                                  .appRepoLink
                          ),
                          new TextSpan(
                              style: aboutTextStyle,
                              text: '.'
                          ),
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

      body: new Container(
        padding: const EdgeInsets.all(18.0),
        child: new ListView(
          children: <Widget>[
            new RichText(
              textAlign: TextAlign.center,
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontStyle: FontStyle.italic),
                    text: CustomLocalizations
                        .of(context)
                        .aboutText,
                  ),
                  new TextSpan(
                    text: "\u{E815}",
                    style: new TextStyle(
                      fontFamily: "MaterialIcons",
                      color: Theme
                          .of(context)
                          .textTheme
                          .title
                          .color,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            new Container(
              padding: const EdgeInsets.only(left: 18.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: 100.0,
                    width: 100.0,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: const AssetImage("images/aga.jpg"),
                      ),
                    ),
                  ),
                  new Text(
                    "Agnieszka Jakubas",
                    textAlign: TextAlign.left,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  new Text(
                    "agnieszka.jakubas@ulicastefankowa.pl",
                    textAlign: TextAlign.left,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}