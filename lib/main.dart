import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import './Paragraph.dart';
import './Post.dart';
import './PostPage.dart';

const double _kFlexibleSpaceMaxHeight = 180.0;

const List<Color> _kTitleColors = const <Color>[
  const Color(0xffef9c20),
  const Color(0xff35c4d5),
  const Color(0xff3c8bac),
  const Color(0xffef9ecc),
  const Color(0xff51ba50),
];

const MaterialColor lightBlue = const MaterialColor(
  _lightBluePrimaryValue,
  const <int, Color>{
    50: const Color(0xfff8fffe),
    100: const Color(0xfff7fffd),
    200: const Color(0xfff6fffc),
    300: const Color(0xfff5fffb),
    400: const Color(0xfff4fffA),
    500: const Color(_lightBluePrimaryValue),
    600: const Color(0xFFE1F5FE),
    700: const Color(0xFFB3E5FC),
    800: const Color(0xFF81D4FA),
    900: const Color(0xFF4FC3F7)
  },
);

const int _lightBluePrimaryValue = 0xfff3fef9;

const String _name = 'UliCa SteFAnkOwA';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _name,
      theme: new ThemeData(
        primarySwatch: lightBlue,
      ),
      home: new MyHomePage(title: _name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();

  List<Post> _posts = new List();
  StreamSubscription<List<Post>> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  StreamSubscription<List<Post>> _fetch() {
    return new Observable.fromFuture(createHttpClient().get(
        "https://ulicastefankowa.prismic.io/api/v2/documents/search?ref=WgNPzioAAADJ3RWO#format=json"))
        .map((response) => JSON.decode(response.body))
        .map((json) => json["results"].map(_parsePost).toList())
        .listen((respo) =>
        setState(() {
          _posts = respo;
        }));
  }

  Paragraph _getParagraph(dynamic paragraph) {
    String text =  paragraph["text"];
    var spans = paragraph["spans"].map((it) =>
    new Span(start: it["start"],
        end: it["end"],
        type: it["type"]))
    .toList();
    return new Paragraph(text: paragraph["text"], spans: _getSpan(spans, text).toList());
  }

  Iterable<ProperSpan> _getSpan(List<Span> spans, String text) sync* {
    num start = 0;
    for (var span in spans) {
      if (span.start == start) {
        yield new ProperSpan(text: text.substring(span.start, span.end) + "\n\n", type: span.type);
        start = span.end;
      } else if (span.start != start) {
        yield new ProperSpan(text: text.substring(start, span.start - 1) + "\n\n", type: "normal");
        start = span.start - 1;
        yield new ProperSpan(text: text.substring(start, span.end) + "\n\n", type: span.type);
        start = span.end;
      }
    }
    if (start <= text.length - 1) {
      yield new ProperSpan(text: text.substring(start) + "\n", type: "normal");
    }
  }

  Post _parsePost(dynamic post) {
    var body = post["data"];
    var image = body["image"]["url"];
    var title = body["title"].first["text"];
    var description = body["description"].first["text"];
    var text = body["text"].map((it) => _getParagraph(it)).toList();
    return new Post(
        title: title, imageUrl: image, description: description, text: text);
  }

  List<Widget> buildItem(List<Post> posts) {
    return posts
        .map((post) => new Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new InkWell(
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      builder: (_) => new PostPage(post: post),
                    )),
                child: new Card(
                  child: new Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      new Image.network(post.imageUrl),
                      new Container(
                          padding: const EdgeInsets.all(16.0),
                          child: new Text(post.title,
                              style: new TextStyle(
                                fontFamily: "Lobster",
                                fontSize: 25.0,
                              ))),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }

  Widget buildTitle(String title, List<Color> colors) {
    var list = new List<Widget>();
    for (var i = 0; i < title.length; i++) {
      final letter = new String.fromCharCode(title.codeUnitAt(i));
      list.add(new Text(
        letter,
        style: new TextStyle(
          color: colors[i % colors.length],
        ),
      ));
    }
    return new Row(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: _kFlexibleSpaceMaxHeight,
              flexibleSpace: new FlexibleSpaceBar(
                title: buildTitle(_name, _kTitleColors),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.asset(
                      'images/header.jpg',
                      fit: BoxFit.cover,
                      height: _kFlexibleSpaceMaxHeight,
                    ),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [.7, 1.0],
                          colors: const <Color>[
                            const Color(0x00000000),
                            const Color(0x60FF5722)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverList(
                delegate: new SliverChildListDelegate(buildItem(_posts))),
          ],
        ));
  }
}


