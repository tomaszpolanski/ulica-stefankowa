import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class PhotoHero extends StatelessWidget {
  const PhotoHero({ Key key, this.photo, this.onTap})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Hero(
        tag: photo,
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
            onTap: onTap,
            child: new Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}