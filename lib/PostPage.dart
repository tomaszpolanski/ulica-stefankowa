import 'package:flutter/material.dart';
import 'package:ulicastefankowa/PhotoHero.dart';

import './Post.dart';

const double _kFlexibleSpaceMaxHeight = 200.0;
const TextStyle _kBodyFont = const TextStyle(
    fontFamily: "Serif", fontSize: 20.0, wordSpacing: 4.0, color: Colors.black);

class PostPage extends StatelessWidget {
  const PostPage({this.post, Key key}) : super(key: key);

  final Post post;

  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();

  TextStyle _getStyle(String type) {
    switch (type) {
      case "strong":
        return _kBodyFont.copyWith(fontWeight: FontWeight.bold);
      case "em":
        return _kBodyFont.copyWith(fontStyle: FontStyle.italic);
      case "normal":
      default:
        return _kBodyFont;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(post.title),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            new PhotoHero(
              photo: post.imageUrl,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child:
              new RichText(
                textAlign: TextAlign.justify,
                text: new TextSpan(
                    children: post.text.expand((it) =>
                        it.spans.map((span) =>
                        new TextSpan(
                            text: span.text,
                            style: _getStyle(span.type))
                        ))
                        .toList()
                ),
              ),
            ),
          ],
        )
    );
  }
}

