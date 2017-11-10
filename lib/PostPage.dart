import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulicastefankowa/PhotoHero.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

import './Post.dart';

const double _kFlexibleSpaceMaxHeight = 200.0;
const TextStyle _kBodyFont = const TextStyle(
    fontFamily: "Serif", fontSize: 20.0, wordSpacing: 4.0, color: Colors.black);

class PostPage extends StatefulWidget {
  const PostPage({this.post, Key key}) : super(key: key);

  final Post post;

  @override
  _PostPageState createState() => new _PostPageState();

}

class _PostPageState extends State<PostPage> {

  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _delayText();
  }

  Future _delayText() async {
    // TODO Temporary solution until connected to navigation transition callback
    await new Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _showText = true;
    });
  }

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
              title: buildTitle(widget.post.title, Theme
                  .of(context)
                  .textTheme
                  .title)
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(<Widget>[
              new PhotoHero(
                photo: widget.post.imageUrl,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              _showText ? new Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                child:
                new RichText(
                  textAlign: TextAlign.justify,
                  text: new TextSpan(
                      children: widget.post.text.expand((it) =>
                          it.spans.map((span) =>
                          new TextSpan(
                              text: span.text,
                              style: _getStyle(span.type))
                          ))
                          .toList()
                  ),
                ),
              )
                  : new Container(),
            ],
            ),
          ),
        ],
      ),
    );
  }
}

