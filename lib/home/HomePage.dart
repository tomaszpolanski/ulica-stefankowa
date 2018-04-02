import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:ulicastefankowa/MainDrawer.dart';
import 'package:ulicastefankowa/post/Paragraph.dart';
import 'package:ulicastefankowa/ui/PhotoHero.dart';
import 'package:ulicastefankowa/post/Post.dart';
import 'package:ulicastefankowa/post/PostPage.dart';
import 'package:ulicastefankowa/i18n/Localizations.dart';
import 'package:ulicastefankowa/network/Prismic.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

const double _kFlexibleSpaceMaxHeight = 180.0;

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    @required this.prismic,
    this.useLightTheme,
    @required this.onThemeChanged,
    this.timeDilation,
    this.onTimeDilationChanged,
    this.fontSize,
    this.onFontSizeChanged,
  })
      : assert(prismic != null),
        assert(onThemeChanged != null),
        assert(onTimeDilationChanged != null),
        assert(onFontSizeChanged != null),
        super(key: key);

  final Prismic prismic;

  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double timeDilation;
  final ValueChanged<double> onTimeDilationChanged;


  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class PostCard {
  PostCard({this.post, this.animationController});

  final Post post;
  final AnimationController animationController;
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();

  List<PostCard> _posts = new List();
  StreamSubscription<List<PostCard>> _subscription;


  @override
  void initState() {
    super.initState();
    _subscription = _fetch();
  }

  @override
  void dispose() {
    for (PostCard post in _posts) {
      post.animationController.dispose();
    }
    _subscription.cancel();
    super.dispose();
  }

  StreamSubscription<List<PostCard>> _fetch() {
    return widget.prismic.getPosts()
        .map((json) =>
        json["results"]
            .map(_parsePost)
            .map(_postCard)
            .toList())
        .listen((respo) =>
        setState(() {
          _posts = respo;
        }));
  }

  Paragraph _getParagraph(dynamic paragraph) {
    if (paragraph["text"] != null) {
      String text = paragraph["text"] + "\n";
      var spans = paragraph["spans"].map((it) =>
      new Span(start: it["start"],
          end: it["end"],
          type: it["type"]))
          .toList();
      return new TextParagraph(
          text: paragraph["text"], spans: _getSpan(spans, text).toList());
    } else if (paragraph["url"] != null) {
      return new ImageParagraph(
          url: paragraph["url"]);
    } else {
      return null;
    }
  }

  Iterable<ProperSpan> _getSpan(List<Span> spans, String text) sync* {
    num start = 0;
    for (var span in spans) {
      if (span.start == start) {
        yield new ProperSpan(
            text: text.substring(span.start, span.end),
            type: span.type);
        start = span.end;
      } else if (span.start != start) {
        yield new ProperSpan(
            text: text.substring(start, span.start - 1),
            type: "normal");
        start = span.start - 1;
        yield new ProperSpan(
            text: text.substring(start, span.end), type: span.type);
        start = span.end;
      }
    }
    if (start <= text.length) {
      yield new ProperSpan(text: text.substring(start) + "\n", type: "normal");
    }
  }

  Post _parsePost(dynamic post) {
    var body = post["data"];
    var image = body["image"]["url"];
    var title = body["title"].first["text"];
    var description = body["description"].first["text"];
    var text = body["text"]
        .map((it) => _getParagraph(it))
        .where((it) => it != null)
        .toList();
    return new Post(
        title: title, imageUrl: image, description: description, text: text);
  }

  PostCard _postCard(dynamic post) {
    var animationController = new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    );
    animationController.forward();
    return new PostCard(post: post, animationController: animationController);
  }

  List<Widget> buildItem(List<PostCard> posts) {
    return posts
        .map((post) =>
    new FadeTransition(
      opacity: post.animationController,
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new InkWell(
          onTap: () {
            Navigator.of(context).push(new FullSlideTransitionRoute(
              settings: const RouteSettings(),
              builder: (_) =>
              new PostPage(
                post: post.post,
                useLightTheme: widget.useLightTheme,
                onThemeChanged: widget.onThemeChanged,
                textScale: widget.fontSize,
              ),
            ),
            );
          },
          child: new Card(
            child: new Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                new PhotoHero(
                  photo: post.post.imageUrl,
                ),
                new Container(
                  decoration: new BoxDecoration(
                    color: Theme
                        .of(context)
                        .backgroundColor,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: buildThemedText(
                    post.post.title,
                    const TextStyle(
                      fontFamily: "Lobster",
                      fontSize: 25.0,
                    ),
                    Theme
                        .of(context)
                        .brightness,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer: new MainDrawer(
        title: CustomLocalizations
            .of(context)
            .title,
        useLightTheme: widget.useLightTheme,
        onThemeChanged: widget.onThemeChanged,
        timeDilation: widget.timeDilation,
        onTimeDilationChanged: widget.onTimeDilationChanged,
        textScaleFactor: widget.fontSize,
        onTextScaleFactorChanged: widget.onFontSizeChanged,
      ),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: _kFlexibleSpaceMaxHeight,
            flexibleSpace: new FlexibleSpaceBar(
              title: buildThemedText(CustomLocalizations
                  .of(context)
                  .title,
                  Theme
                      .of(context)
                      .textTheme
                      .title,
                  Theme
                      .of(context)
                      .brightness),
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image.asset(Theme
                      .of(context)
                      .brightness == Brightness.dark
                      ? 'images/header-dark.png' // I know it is a horror picture. Header needs to have removed background.
                      : 'images/header.jpg',
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
      ),
    );
  }
}


class FullSlideTransitionRoute<T> extends MaterialPageRoute<T> {
  FullSlideTransitionRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  final Tween<Offset> _kBottomUpTween = new Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) =>
      new SlideTransition(
          position: _kBottomUpTween.animate(
            new CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child);
}

