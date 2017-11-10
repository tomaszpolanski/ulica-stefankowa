import 'package:flutter/material.dart';
import 'package:ulicastefankowa/PhotoHero.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
              floating: true,
              title: buildTitle(post.title, Theme
                  .of(context)
                  .textTheme
                  .title)
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(<Widget>[
              new PhotoHero(
                photo: post.imageUrl,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              new Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
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
            ),
          ),
        ],
      ),
    );
  }
}

