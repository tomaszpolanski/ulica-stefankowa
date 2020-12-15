import 'package:flutter/material.dart';

class AppTextTheme {
  const AppTextTheme(this._textTheme);

  factory AppTextTheme.of(BuildContext context) =>
      AppTextTheme(Theme.of(context).textTheme);
  final TextTheme _textTheme;

  TextStyle get h1 => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 36,
        color: _textTheme.bodyText1.color,
        fontWeight: FontWeight.w700,
      );

  TextStyle get h2 => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 24,
        color: _textTheme.bodyText1.color,
        fontWeight: FontWeight.w700,
      );

  TextStyle get h3 => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 18,
        color: _textTheme.bodyText1.color,
        fontWeight: FontWeight.w700,
      );

  TextStyle get h4 => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 16,
        color: _textTheme.bodyText1.color,
        fontWeight: FontWeight.w700,
      );

  TextStyle get h5 => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14,
        color: _textTheme.bodyText1.color,
        fontWeight: FontWeight.w700,
      );

  TextStyle get h6 => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 12,
        color: _textTheme.bodyText1.color,
        fontWeight: FontWeight.w700,
      );

  TextStyle get paragraph => _textTheme.headline6.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  TextStyle get medium => _textTheme.headline6.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  TextStyle get s1 => const TextStyle(
        fontFamily: 'Lobster',
        fontSize: 36,
      );

  TextStyle get post =>
      _textTheme.headline6.copyWith(fontFamily: 'Serif', wordSpacing: 4);
}
