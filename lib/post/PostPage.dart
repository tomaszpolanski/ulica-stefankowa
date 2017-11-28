import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ulicastefankowa/post/Paragraph.dart';
import 'package:ulicastefankowa/ui/PhotoHero.dart';
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

  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();


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

  TextSpan _getSpan(ProperSpan span) {
    return new TextSpan(
      text: span.text,
      style: _getStyle(span.type, Theme
          .of(context)
          .textTheme
          .title
          .copyWith(fontSize: widget.textScale),
      ),
    );
  }

  List<Widget> _getWidgets() {
    List<Widget> content = [
      new Container(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: new PhotoHero(
          photo: widget.post.imageUrl,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      )
    ];
    content.addAll(widget.post.text.map((it) =>
    it is TextParagraph
        ? _buildTextParagraphs(it.spans.map((span) => _getSpan(span)))
        : it is ImageParagraph
        ? _buildImageParagraphs(it.url)
        : new Container()
    ));
    return content;
  }

  Widget _buildTextParagraphs(Iterable<TextSpan> spans) {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new RichText(
        textAlign: TextAlign.justify,
        text: new TextSpan(
          children: spans.toList(),
        ),
      ),
    );
  }

  Widget _buildImageParagraphs(String image) {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new FadeInImage.assetNetwork(
        image: image,
        placeholder: 'images/header.jpg',
        fit: BoxFit.contain,
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
                  .brightness,
            ),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.visibility),
                tooltip: 'Theme',
                onPressed: () => widget.onThemeChanged(!widget.useLightTheme),
              ),
            ],
          ),
          new SliverList(delegate: new SliverChildListDelegate(_getWidgets())),
        ],
      ),
    );
  }
}

