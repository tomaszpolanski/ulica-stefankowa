import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ulicastefankowa/PhotoHero.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

import './Post.dart';

const double _kFlexibleSpaceMaxHeight = 200.0;

class PostPage extends StatefulWidget {
  const PostPage({
    Key key,
    this.post,
    this.useLightTheme,
    @required this.onThemeChanged,
    this.textScale})
      : assert(onThemeChanged != null),
        super(key: key);

  final Post post;
  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double textScale;

  @override
  _PostPageState createState() => new _PostPageState();

}

class _PostPageState extends State<PostPage> with TickerProviderStateMixin {

  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();
  AnimationController _controller;
  Animation<double> _paragraphContentsOpacity;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _paragraphContentsOpacity = new CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    _controller.forward();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle _getStyle(String type, TextStyle style) {
    switch (type) {
      case "strong":
        return style.copyWith(fontWeight: FontWeight.bold,
            fontFamily: "Serif",
            wordSpacing: 4.0);
      case "em":
        return style.copyWith(fontStyle: FontStyle.italic,
            fontFamily: "Serif",
            wordSpacing: 4.0);
      case "normal":
      default:
        return style.copyWith(
            fontFamily: "Serif", wordSpacing: 4.0);
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
                .title
                .copyWith(fontSize: widget.textScale)))
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
            title: buildThemedText(widget.post.title,
                Theme
                    .of(context)
                    .textTheme
                    .title,
                Theme
                    .of(context)
                    .brightness
            ),
            actions: <Widget>[
              new IconButton(
                  icon: const Icon(Icons.visibility),
                  tooltip: 'Theme',
                  onPressed: () => widget.onThemeChanged(!widget.useLightTheme)
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
              new FadeTransition(
                  opacity: _paragraphContentsOpacity,
                  child: _buildParagraphs(_getText().skip(3))
              )
            ],
            ),
          ),
        ],
      ),
    );
  }
}

