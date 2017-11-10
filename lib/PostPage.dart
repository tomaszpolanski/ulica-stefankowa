import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ulicastefankowa/PhotoHero.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

import './Post.dart';

const double _kFlexibleSpaceMaxHeight = 200.0;
const TextStyle _kBodyFont = const TextStyle(
    fontFamily: "Serif", fontSize: 20.0, wordSpacing: 4.0);

class PostPage extends StatefulWidget {
  const PostPage({
    Key key,
    this.post,
    this.useLightTheme,
    @required this.onThemeChanged})
      : assert(onThemeChanged != null),
        super(key: key);

  final Post post;
  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

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

  TextStyle _getStyle(String type, TextStyle style) {
    switch (type) {
      case "strong":
        return style.copyWith(fontWeight: FontWeight.bold,
            fontFamily: "Serif",
            fontSize: 20.0,
            wordSpacing: 4.0);
      case "em":
        return style.copyWith(fontStyle: FontStyle.italic,
            fontFamily: "Serif",
            fontSize: 20.0,
            wordSpacing: 4.0);
      case "normal":
      default:
        return style.copyWith(
            fontFamily: "Serif", fontSize: 20.0, wordSpacing: 4.0);
    }
  }

  Iterable<TextSpan> _getText() {
    return widget.post.text.expand((it) =>
        it.spans.map((span) =>
        new TextSpan(
            text: span.text,
            style: _getStyle(span.type, Theme
                .of(context)
                .textTheme
                .title))
        ));
  }

  Widget _buildParagraphs(Iterable<TextSpan> spans) {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new RichText(
        textAlign: TextAlign.justify,
        text: new TextSpan(
            children: spans
                .toList()
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            floating: true,
            title: buildTitle(widget.post.title, Theme
                .of(context)
                .textTheme
                .title),
            actions: <Widget>[
              new IconButton(
                  icon: const Icon(Icons.visibility),
                  tooltip: 'Theme',
                  onPressed: () => widget.onThemeChanged(!widget.useLightTheme) // _showShoppingCart
              )
            ],
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(<Widget>[
              new Container(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: new PhotoHero(
                  photo: widget.post.imageUrl,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              _buildParagraphs(_getText().take(3)),
              _showText
                  ? _buildParagraphs(_getText().skip(3))
                  : new Container(),
            ],
            ),
          ),
        ],
      ),
    );
  }
}

