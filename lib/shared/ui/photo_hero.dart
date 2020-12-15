import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap}) : super(key: key);

  final String photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: FadeInImage.assetNetwork(
              image: photo,
              placeholder: 'images/header.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
