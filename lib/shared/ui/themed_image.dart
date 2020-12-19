import 'package:flutter/material.dart';

class ThemedImage extends StatelessWidget {
  const ThemedImage({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: Theme.of(context).brightness == Brightness.dark ? 0.6 : 1.0,
      child: child,
    );
  }
}
