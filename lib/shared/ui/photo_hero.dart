import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ulicastefankowa/shared/ui/themed_image.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    Key? key,
    required this.photo,
    this.onTap,
  }) : super(key: key);

  final String photo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const enable = !kIsWeb;
    final child = GestureDetector(
      onTap: onTap,
      child: ThemedImage(
        child: FadeInImage.assetNetwork(
          image: photo,
          placeholder: 'images/header.jpg',
          fit: BoxFit.contain,
        ),
      ),
    );
    return enable
        ? SizedBox(
            child: Hero(
              tag: photo,
              child: child,
            ),
          )
        : child;
  }
}
