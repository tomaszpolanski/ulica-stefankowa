import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:ulicastefankowa/about/AboutPage.dart';
import 'package:ulicastefankowa/i18n/Localizations.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
    @required this.title,
    this.useLightTheme,
    this.onThemeChanged,
    this.timeDilation,
    this.onTimeDilationChanged,
    this.textScaleFactor,
    this.onTextScaleFactorChanged,
  })  : assert(title != null),
        assert(onThemeChanged != null),
        assert(onTimeDilationChanged != null),
        super(key: key);

  final String title;

  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double timeDilation;
  final ValueChanged<double> onTimeDilationChanged;

  final double textScaleFactor;
  final ValueChanged<double> onTextScaleFactorChanged;

  @override
  Widget build(BuildContext context) {
    final Widget lightThemeItem = new SwitchListTile(
        title: new Text(CustomLocalizations.of(context).useLightTheme),
        value: useLightTheme,
        onChanged: onThemeChanged);

    final Widget animateSlowlyItem = new CheckboxListTile(
      title: new Text(CustomLocalizations.of(context).slowAnimations),
      value: timeDilation != 1.0,
      onChanged: (bool value) {
        onTimeDilationChanged(value ? 20.0 : 1.0);
      },
      secondary: const Icon(Icons.hourglass_empty),
      selected: timeDilation != 1.0,
    );

    final Widget aboutItem = new ListTile(
      leading: new Image.asset('images/logo.png', fit: BoxFit.cover),
      title: new Text(CustomLocalizations.of(context).aboutBlog),
      onTap: () => Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) =>
              new AboutPage(title: CustomLocalizations.of(context).aboutBlog))),
    );

    final List<Widget> allDrawerItems = <Widget>[
      new Container(
        padding: const EdgeInsets.only(
            top: 30.0, left: 20.0, right: 20.0, bottom: 10.0),
        child: buildThemedText(
            title,
            const TextStyle(
              fontFamily: "Lobster",
              fontSize: 25.0,
            ).copyWith(fontSize: Theme.of(context).textTheme.display1.fontSize),
            Theme.of(context).brightness),
      ),
      lightThemeItem,
      const Divider(),
      const Divider(),
      new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            CustomLocalizations.of(context).postFontSize,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title.copyWith(
                fontFamily: "Serif",
                wordSpacing: 4.0,
                fontSize: textScaleFactor),
          ),
          new Slider(
            value: textScaleFactor,
            min: 10.0,
            max: 40.0,
            label: '${textScaleFactor.round()}',
            activeColor: Theme.of(context).accentColor,
            onChanged: onTextScaleFactorChanged,
          ),
        ],
      ),
    ];

    allDrawerItems
      ..addAll(<Widget>[
        const Divider(),
        animateSlowlyItem,
        const Divider(),
      ]);

    allDrawerItems.addAll(<Widget>[
      aboutItem,
    ]);

    return new Drawer(
        child: new ListView(primary: false, children: allDrawerItems));
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

  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launch(url);
              });
}
