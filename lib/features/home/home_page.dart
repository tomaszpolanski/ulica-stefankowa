import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ulicastefankowa/features/drawer/main_drawer.dart';
import 'package:ulicastefankowa/features/post/paragraph.dart';
import 'package:ulicastefankowa/features/post/post.dart';
import 'package:ulicastefankowa/features/post/post_page.dart';
import 'package:ulicastefankowa/shared/network/prismic.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/ui/photo_hero.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';

const double _kFlexibleSpaceMaxHeight = 230;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.prismic,
    required this.useLightTheme,
    required this.onThemeChanged,
    required this.fontSize,
    required this.onFontSizeChanged,
  }) : super(key: key);

  final Prismic prismic;

  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class PostCard {
  PostCard({
    required this.post,
    required this.animationController,
  });

  final Post post;
  final AnimationController animationController;
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  var _posts = <PostCard>[];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _posts.map((e) => e.animationController).forEach((it) => it.dispose());
    super.dispose();
  }

  Future<void> _fetch() async {
    final json = await widget.prismic.getPosts();
    setState(() {
      _posts = json.map(_parsePost).map(_postCard).toList();
    });
  }

  Paragraph? _getParagraph(dynamic paragraph) {
    if (paragraph['text'] != null) {
      final String text = '${paragraph['text']}\n';
      final spans = paragraph['spans']
          .map<Span>((dynamic it) =>
              Span(start: it['start'], end: it['end'], type: it['type']))
          .toList();
      return TextParagraph(
          text: paragraph['text'], spans: _getSpan(spans, text).toList());
    } else if (paragraph['url'] != null) {
      return ImageParagraph(url: paragraph['url']);
    } else {
      return null;
    }
  }

  Iterable<ProperSpan> _getSpan(List<Span> spans, String text) sync* {
    int start = 0;
    for (final span in spans) {
      if (span.start == start) {
        yield ProperSpan(
            text: text.substring(span.start, span.end), type: span.type);
        start = span.end;
      } else if (span.start != start) {
        yield ProperSpan(
          text: text.substring(start, span.start - 1),
          type: 'normal',
        );
        start = span.start - 1;
        yield ProperSpan(
            text: text.substring(start, span.end), type: span.type);
        start = span.end;
      }
    }
    if (start <= text.length) {
      yield ProperSpan(
        text: '${text.substring(start)}\n',
        type: 'normal',
      );
    }
  }

  Post _parsePost(Map<String, dynamic> body) {
    final image = body['image']['url'];
    final title = body['title'].first['text'];
    final description = body['description'].first['text'];
    final text = body['text']
        .map<Paragraph>(_getParagraph)
        .where((dynamic it) => it != null)
        .toList();
    return Post(
        title: title, imageUrl: image, description: description, text: text);
  }

  PostCard _postCard(dynamic post) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    return PostCard(post: post, animationController: animationController);
  }

  List<Widget> buildItem(List<PostCard> posts) {
    return posts
        .map(
          (post) => FadeTransition(
            opacity: post.animationController,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)?.push(
                    FullSlideTransitionRoute<void>(
                      settings: const RouteSettings(),
                      builder: (_) => PostPage(
                        post: post.post,
                        useLightTheme: widget.useLightTheme,
                        onThemeChanged: widget.onThemeChanged,
                        textScale: widget.fontSize,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      PhotoHero(
                        photo: post.post.imageUrl,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: StefanText(
                          post.post.title,
                          style: AppTextTheme.of(context).s1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(
        title: AppLocalizations.of(context).title,
        useLightTheme: widget.useLightTheme,
        onThemeChanged: widget.onThemeChanged,
        textScaleFactor: widget.fontSize,
        onTextScaleFactorChanged: widget.onFontSizeChanged,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: _kFlexibleSpaceMaxHeight,
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: Icon(Icons.menu, color: Theme.of(context).accentColor),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: StefanText(
                AppLocalizations.of(context).title,
                style: AppTextTheme.of(context).s1,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'images/header-dark.png' // I know it is a horror picture. Header needs to have removed background.
                        : 'images/header.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    height: _kFlexibleSpaceMaxHeight,
                  ),
                ],
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(buildItem(_posts))),
        ],
      ),
    );
  }
}

class FullSlideTransitionRoute<T> extends MaterialPageRoute<T> {
  FullSlideTransitionRoute(
      {required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  final Tween<Offset> _kBottomUpTween = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: _kBottomUpTween.animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      );
}
