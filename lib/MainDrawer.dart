import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
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
    this.showPerformanceOverlay,
    this.onShowPerformanceOverlayChanged,
    this.checkerboardRasterCacheImages,
    this.onCheckerboardRasterCacheImagesChanged,
    this.checkerboardOffscreenLayers,
    this.onCheckerboardOffscreenLayersChanged,
    this.onPlatformChanged,
    this.onSendFeedback,
  })
      : assert(title != null),
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

  final bool showPerformanceOverlay;
  final ValueChanged<bool> onShowPerformanceOverlayChanged;

  final bool checkerboardRasterCacheImages;
  final ValueChanged<bool> onCheckerboardRasterCacheImagesChanged;

  final bool checkerboardOffscreenLayers;
  final ValueChanged<bool> onCheckerboardOffscreenLayersChanged;

  final ValueChanged<TargetPlatform> onPlatformChanged;

  final VoidCallback onSendFeedback;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(
        color: themeData.accentColor);

    final Widget lightThemeItem =
    new SwitchListTile(
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


    final Widget aboutItem = new AboutListTile(
        icon: new Image.asset(
            'images/logo.png',
            fit: BoxFit.cover),
        applicationVersion: CustomLocalizations.of(context).appVersion,
        applicationIcon: new Image.asset(
            'images/logo.png',
            height: 100.0,
            fit: BoxFit.cover),
        applicationLegalese: CustomLocalizations.of(context).appCopy,
        aboutBoxChildren: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: new RichText(
                  text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                            style: aboutTextStyle,
                            text: CustomLocalizations.of(context).appDescription
                        ),
                        new LinkTextSpan(
                            style: linkStyle,
                            url: 'http://ulicastefankowa.pl'
                        ),
                        new TextSpan(
                            style: aboutTextStyle,
                            text: CustomLocalizations.of(context).appSourceCode
                        ),
                        new LinkTextSpan(
                            style: linkStyle,
                            url: 'https://goo.gl/cYD8Dq',
                            text: CustomLocalizations.of(context).appRepoLink
                        ),
                        new TextSpan(
                            style: aboutTextStyle,
                            text: '.'
                        )
                      ]
                  )
              )
          )
        ]
    );

    final List<Widget> allDrawerItems = <Widget>[
      new Container(
        padding: const EdgeInsets.only(
            top: 30.0, left: 20.0, right: 20.0, bottom: 10.0),
        child: buildTitle(title, Theme
            .of(context)
            .textTheme
            .display2),
      ),
      lightThemeItem,
      const Divider(),
      const Divider(),
      new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(CustomLocalizations.of(context).postFontSize,
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .title
                  .copyWith(fontFamily: "Serif",
                  wordSpacing: 4.0,
                  fontSize: textScaleFactor)),
          new Slider(
              value: textScaleFactor,
              min: 10.0,
              max: 40.0,
              label: '${textScaleFactor.round()}',
              thumbOpenAtMin: true,
              onChanged: onTextScaleFactorChanged
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

    bool addedOptionalItem = false;
    if (onCheckerboardOffscreenLayersChanged != null) {
      allDrawerItems.add(new CheckboxListTile(
        title: const Text('Checkerboard Offscreen Layers'),
        value: checkerboardOffscreenLayers,
        onChanged: onCheckerboardOffscreenLayersChanged,
        secondary: const Icon(Icons.assessment),
        selected: checkerboardOffscreenLayers,
      ));
      addedOptionalItem = true;
    }

    if (onCheckerboardRasterCacheImagesChanged != null) {
      allDrawerItems.add(new CheckboxListTile(
        title: const Text('Checkerboard Raster Cache Images'),
        value: checkerboardRasterCacheImages,
        onChanged: onCheckerboardRasterCacheImagesChanged,
        secondary: const Icon(Icons.assessment),
        selected: checkerboardRasterCacheImages,
      ));
      addedOptionalItem = true;
    }

    if (onShowPerformanceOverlayChanged != null) {
      allDrawerItems.add(new CheckboxListTile(
        title: const Text('Performance Overlay'),
        value: showPerformanceOverlay,
        onChanged: onShowPerformanceOverlayChanged,
        secondary: const Icon(Icons.assessment),
        selected: showPerformanceOverlay,
      ));
      addedOptionalItem = true;
    }

    if (addedOptionalItem)
      allDrawerItems.add(const Divider());

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

  LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: new TapGestureRecognizer()
        ..onTap = () {
          launch(url);
        }
  );
}