import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ulicastefankowa/PhotoHero.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

import './Paragraph.dart';
import './Post.dart';
import './PostPage.dart';

const double _kFlexibleSpaceMaxHeight = 180.0;


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

final ThemeData _kGalleryLightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: lightBlue,
);

final ThemeData _kGalleryDarkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: lightBlue,
);


const int _lightBluePrimaryValue = 0xfff3fef9;

const String _name = 'UliCa SteFAnkOwA';

const String _kYesIKnow_willChange = "MC5XZ1hlYWlnQUFGb0stWmZr.77-9Vi1_Du-_ve-_ve-_ve-_vUkO77-977-9Ou-_ve-_ve-_vWPvv73vv73vv73vv73vv71777-9dSbvv71ube-_ve-_vQ";

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _useLightTheme = true;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _name,
      theme: (_useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme),
      home: new MyHomePage(
          title: _name,
          useLightTheme: _useLightTheme,
          onThemeChanged: (bool value) {
            setState(() {
              _useLightTheme = value;
            });
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
    this.useLightTheme,
    @required this.onThemeChanged})
      : assert(onThemeChanged != null),
        super(key: key);

  final String title;
  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

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
        """https://ulicastefankowa.prismic.io/api/v2""", headers: {
      "accessToken": _kYesIKnow_willChange
    }
    )).map((it) => JSON.decode(it.body)["refs"])
        .flatMap((it) =>
    new Observable.fromFuture(createHttpClient().get(
        """https://ulicastefankowa.prismic.io/api/v2/documents/search?ref=${it
            .first["ref"]}#format=json""", headers: {
      "accessToken": _kYesIKnow_willChange
    }
    )))
        .map((response) => JSON.decode(response.body))
        .map((json) => json["results"].map(_parsePost).toList())
        .listen((respo) =>
        setState(() {
          _posts = respo;
        }));
  }

  Paragraph _getParagraph(dynamic paragraph) {
    String text = paragraph["text"];
    var spans = paragraph["spans"].map((it) =>
    new Span(start: it["start"],
        end: it["end"],
        type: it["type"]))
        .toList();
    return new Paragraph(
        text: paragraph["text"], spans: _getSpan(spans, text).toList());
  }

  Iterable<ProperSpan> _getSpan(List<Span> spans, String text) sync* {
    num start = 0;
    for (var span in spans) {
      if (span.start == start) {
        yield new ProperSpan(
            text: text.substring(span.start, span.end) + "\n\n",
            type: span.type);
        start = span.end;
      } else if (span.start != start) {
        yield new ProperSpan(
            text: text.substring(start, span.start - 1) + "\n\n",
            type: "normal");
        start = span.start - 1;
        yield new ProperSpan(
            text: text.substring(start, span.end) + "\n\n", type: span.type);
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
        .map((post) =>
    new Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new InkWell(
        onTap: () =>
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (_) =>
              new PostPage(
                  post: post,
                  useLightTheme: widget.useLightTheme,
                  onThemeChanged: widget.onThemeChanged),
            )),
        child: new Card(
          child: new Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              new PhotoHero(
                photo: post.imageUrl,
              ),
              new Container(
                decoration: new BoxDecoration(color: Theme
                    .of(context)
                    .backgroundColor
                    .withAlpha(200)),
                padding: const EdgeInsets.all(16.0),
                child: buildTitle(post.title, const TextStyle(
                  fontFamily: "Lobster",
                  fontSize: 25.0,
                )),
              ),
            ],
          ),
        ),
      ),
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: _kFlexibleSpaceMaxHeight,
              flexibleSpace: new FlexibleSpaceBar(
                title: buildTitle(_name, Theme
                    .of(context)
                    .textTheme
                    .title),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.asset(
                      'images/header.jpg',
                      fit: BoxFit.cover,
                      height: _kFlexibleSpaceMaxHeight,
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


