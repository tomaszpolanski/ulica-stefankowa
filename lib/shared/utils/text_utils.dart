import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<Color> _kTitleColors = <Color>[
  Color(0xffef9c20),
  Color(0xff35c4d5),
  Color(0xff3c8bac),
  Color(0xffef9ecc),
  Color(0xff51ba50),
];

const List<Color> _kDarkTitleColors = <Color>[
  Color(0xffef9c20),
  Color(0xff35c4d5),
  Color(0xffc363ff),
  Color(0xffef9ecc),
  Color(0xff5edd5d),
];

Iterable<TextSpan> _getColoredTextSpans(
    TextStyle style, String title, bool isDark) sync* {
  for (var i = 0; i < title.length; i++) {
    final letter = String.fromCharCode(title.codeUnitAt(i));
    yield TextSpan(
      text: letter,
      style: style.copyWith(
        color: isDark ? _dark(i, title) : _light(i, title),
      ),
    );
  }
}

Color _light(int i, String title) {
  return _forTheme(i, title, _kTitleColors);
}

Color _dark(int i, String title) {
  return _forTheme(i, title, _kDarkTitleColors);
}

Color _forTheme(int i, String title, List<Color> colorList) {
  return colorList[(i + title.length) % colorList.length];
}

class StefanText extends StatelessWidget {
  const StefanText(this.data, {this.style, Key key}) : super(key: key);

  final String data;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: _getColoredTextSpans(
                style ?? DefaultTextStyle.of(context).style,
                data,
                brightness == Brightness.dark)
            .toList(),
      ),
    );
  }
}
