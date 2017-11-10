import 'package:flutter/widgets.dart';

const List<Color> _kTitleColors = const <Color>[
  const Color(0xffef9c20),
  const Color(0xff35c4d5),
  const Color(0xff3c8bac),
  const Color(0xffef9ecc),
  const Color(0xff51ba50),
];

RichText buildTitle(String title, TextStyle baseStyle) {
  return new RichText(
    text: new TextSpan(
        children: _getColoredTextSpans(title, baseStyle).toList()),
  );
}

Iterable<TextSpan> _getColoredTextSpans(String title,
    TextStyle baseStyle) sync* {
  for (var i = 0; i < title.length; i++) {
    final letter = new String.fromCharCode(title.codeUnitAt(i));
    yield new TextSpan(
        text: letter,
        style: baseStyle.copyWith(
            color: _kTitleColors[(i + title.length) % _kTitleColors.length])
    );
  }
}