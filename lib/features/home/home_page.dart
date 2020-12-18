import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ulicastefankowa/features/drawer/main_drawer.dart';
import 'package:ulicastefankowa/features/home/home_bloc.dart';
import 'package:ulicastefankowa/features/post/post.dart';
import 'package:ulicastefankowa/shared/navigation/app_router.dart';
import 'package:ulicastefankowa/shared/network/prismic.dart';
import 'package:ulicastefankowa/shared/state/state.dart';
import 'package:ulicastefankowa/shared/storage/settings_bloc.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/ui/debounce_widget.dart';
import 'package:ulicastefankowa/shared/ui/fade_in.dart';
import 'package:ulicastefankowa/shared/ui/photo_hero.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';

const double _kFlexibleSpaceMaxHeight = 230;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.prismic,
    required this.onPageChanged,
  }) : super(key: key);

  final Prismic prismic;
  final ValueChanged<AppRoutePath> onPageChanged;

  @override
  _HomePageState createState() => _HomePageState();
}

class PostCard {
  PostCard({
    required this.post,
    required this.animationController,
  });

  final BasicPost post;
  final AnimationController animationController;
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
    final posts = await widget.prismic.fetchPosts();
    if (mounted) {
      setState(() {
        _posts = posts.map(_postCard).toList();
      });
    }
  }

  PostCard _postCard(BasicPost post) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    return PostCard(post: post, animationController: animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DebounceWidget<double>(
        value: BlocProvider.of<SettingsBloc>(context).state.textSize,
        onChanged: (double size) {
          final current = BlocProvider.of<SettingsBloc>(context).state;
          BlocProvider.of<SettingsBloc>(context).save(
            current.copyWith(textSize: size),
          );
        },
        builder: (context, value, onChanged) => MainDrawer(
          useLightTheme:
              BlocProvider.of<SettingsBloc>(context).state.useLightTheme,
          onThemeChanged: (bool light) {
            final current = BlocProvider.of<SettingsBloc>(context).state;
            BlocProvider.of<SettingsBloc>(context).save(
              current.copyWith(
                useLightTheme: light,
              ),
            );
          },
          textScaleFactor: value,
          onTextScaleFactorChanged: onChanged,
          onPageChanged: widget.onPageChanged,
        ),
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
                AppLocalizations.of(context)!.title,
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
          AppBlocBuilder<HomeBloc, HomeState>(
            onInit: (context) {
              BlocProvider.of<HomeBloc>(context).fetch();
            },
            builder: (context, state) {
              final data = state.data;
              if (data != null) {
                return SliverFadeInWidget(
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, int index) => PostCardItem(
                        data[index],
                        onSelected: (id) {
                          widget.onPageChanged(PostRoutePath(id));
                        },
                      ),
                      childCount: _posts.length,
                    ),
                  ),
                );
              } else {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class PostCardItem extends StatelessWidget {
  const PostCardItem(
    this.post, {
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final BasicPost post;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        width: 720,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: () => onSelected(post.id),
          child: Card(
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                PhotoHero(photo: post.imageUrl),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: StefanText(
                    post.title,
                    style: AppTextTheme.of(context).s1,
                  ),
                ),
              ],
            ),
          ),
        ),
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
