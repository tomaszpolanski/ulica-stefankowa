import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<Color> _kTitleColors = const <Color>[
  const Color(0xffef9c20),
  const Color(0xff35c4d5),
  const Color(0xff3c8bac),
  const Color(0xffef9ecc),
  const Color(0xff51ba50),
];

const List<Color> _kDarkTitleColors = const <Color>[
  const Color(0xffef9c20),
  const Color(0xff35c4d5),
  const Color(0xffc363ff),
  const Color(0xffef9ecc),
  const Color(0xff5edd5d),
];

RichText buildThemedText(String title, TextStyle baseStyle,
    Brightness brightness) =>
    new RichText(
      text: new TextSpan(
          children: _getColoredTextSpans(
              title, baseStyle, brightness == Brightness.dark).toList()),
    );

Iterable<TextSpan> _getColoredTextSpans(String title,
    TextStyle baseStyle, bool isDark) sync* {
  for (var i = 0; i < title.length; i++) {
    final letter = new String.fromCharCode(title.codeUnitAt(i));
    yield new TextSpan(
        text: letter,
        style: baseStyle.copyWith(
            color: isDark ? dark(i, title) : light(i, title))
    );
  }
}

Color light(int i, String title) {
  return forTheme(i, title, _kTitleColors);
}

Color dark(int i, String title) {
  return forTheme(i, title, _kDarkTitleColors);
}

Color forTheme(int i, String title, List<Color> colorList) {
  return colorList[(i + title.length) % colorList.length];
}
