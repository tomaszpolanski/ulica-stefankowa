import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:ulicastefankowa/MainDrawer.dart';
import 'package:ulicastefankowa/PhotoHero.dart';
import 'package:ulicastefankowa/i18n/Localizations.dart';
import 'package:ulicastefankowa/network/Prismic.dart';
import 'package:ulicastefankowa/storage/Settings.dart';
import 'package:ulicastefankowa/utlis/TextUtils.dart';

import './Paragraph.dart';
import './Post.dart';
import './PostPage.dart';

const double _kFlexibleSpaceMaxHeight = 180.0;

final ThemeData _kGalleryLightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: Colors.white,
);

final ThemeData _kGalleryDarkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
);

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState(settings: new Settings());
}

class _MyAppState extends State<MyApp> {
  bool _useLightTheme;
  double _timeDilation;
  double _textScaleFactor;
  Timer _timeDilationTimer;

  Settings settings;
  final PublishSubject<Null> _saveSettingsSubject = new PublishSubject();
  StreamSubscription _saveSettingsSubscription;

  _MyAppState({this.settings});


  @override
  void initState() {
    _useLightTheme = settings.useLightTheme;
    timeDilation = _timeDilation = settings.timeDilation;
    _textScaleFactor = settings.textSize;
    readSettings();
    _saveSettingsSubscription = _saveSettingsSubject
        .stream
        .debounce(new Duration(seconds: 1))
        .listen((_) => settings.saveSettings());
    super.initState();
  }

  Future readSettings() async {
    await settings.readSettings();
    setState(() {
      _useLightTheme = settings.useLightTheme;
      timeDilation = _timeDilation = settings.timeDilation;
      _textScaleFactor = settings.textSize;
    });
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    _timeDilationTimer = null;
    _saveSettingsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateTitle: (context) =>
      CustomLocalizations
          .of(context)
          .title,
      localizationsDelegates: [
        const CustomLocalizationsDelegate(),
        PolishMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('pl', ''),
      ],
      theme: (_useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme),
      home: new MyHomePage(
        prismic: new Prismic(),
        useLightTheme: _useLightTheme,
        onThemeChanged: (bool value) {
          setState(() {
            _useLightTheme = settings.useLightTheme = value;
          });
          _saveSettingsSubject.add(null);
        },
        timeDilation: _timeDilation,
        onTimeDilationChanged: (double value) {
          setState(() {
            _timeDilationTimer?.cancel();
            _timeDilationTimer = null;
            _timeDilation = settings.timeDilation = value;
            if (_timeDilation > 1.0) {
              // We delay the time dilation change long enough that the user can see
              // that the checkbox in the drawer has started reacting, then we slam
              // on the brakes so that they see that the time is in fact now dilated.
              _timeDilationTimer =
              new Timer(const Duration(milliseconds: 150), () {
                timeDilation = _timeDilation;
              });
            } else {
              timeDilation = _timeDilation;
            }
          });
          _saveSettingsSubject.add(null);
        },
        fontSize: _textScaleFactor,
        onFontSizeChanged: (double value) {
          setState(() {
            _textScaleFactor = settings.textSize = value;
          });

          _saveSettingsSubject.add(null);
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
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
    String text = paragraph["text"] + "\n";
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
    var text = body["text"].map((it) => _getParagraph(it)).toList();
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
    new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: post.animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new InkWell(
          onTap: () =>
              Navigator.of(context).push(new FullSlideTransitionRoute(
                settings: const RouteSettings(),
                builder: (_) =>
                new PostPage(
                    post: post.post,
                    useLightTheme: widget.useLightTheme,
                    onThemeChanged: widget.onThemeChanged,
                    textScale: widget.fontSize),
              )),
          child: new Card(
            child: new Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                new PhotoHero(
                  photo: post.post.imageUrl,
                ),
                new Container(
                  decoration: new BoxDecoration(color: Theme
                      .of(context)
                      .backgroundColor),
                  padding: const EdgeInsets.all(16.0),
                  child: buildThemedText(post.post.title,
                      const TextStyle(
                        fontFamily: "Lobster",
                        fontSize: 25.0,),
                      Theme
                          .of(context)
                          .brightness),
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
//          showPerformanceOverlay: widget.showPerformanceOverlay,
//          onShowPerformanceOverlayChanged: widget.onShowPerformanceOverlayChanged,
//          checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
//          onCheckerboardRasterCacheImagesChanged: widget.onCheckerboardRasterCacheImagesChanged,
//          checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
//          onCheckerboardOffscreenLayersChanged: widget.onCheckerboardOffscreenLayersChanged,
//          onPlatformChanged: widget.onPlatformChanged,
//          onSendFeedback: widget.onSendFeedback,
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
        ));
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
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return new SlideTransition(position: _kBottomUpTween.animate(new CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
    )), child: child);
  }
}
