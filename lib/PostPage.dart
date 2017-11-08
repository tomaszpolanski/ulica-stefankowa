import 'package:flutter/material.dart';

import './Post.dart';

const double _kFlexibleSpaceMaxHeight = 200.0;
const TextStyle _kBodyFont = const TextStyle(
    fontFamily: "Serif", fontSize: 20.0, wordSpacing: 4.0, color: Colors.black);

class PostPage extends StatefulWidget {
  const PostPage({Post this.post, Key key}) : super(key: key);

  final Post post;

  @override
  State<PostPage> createState() => new PostPageState(this.post);
}

class PostPageState extends State<PostPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  Post _post;


  PostPageState(Post post) {
    this._post = post;
  }

  @override
  void initState() {
    super.initState();
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
        appBar: new AppBar(
          title: new Text(_post.title),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            new Image.network(_post.imageUrl),
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child:
              new RichText(
                textAlign: TextAlign.justify,
                text: new TextSpan(
                    children: _post.text.map((it) => it.spans.first)
                        .map((it) =>
                    new TextSpan(
                        text: it.text,
                        style: _getStyle(it.type))
                    ).toList()
                ),
              ),
            ),
          ],
        )
    );
  }
}
