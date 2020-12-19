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
import 'package:ulicastefankowa/shared/state/state.dart';
import 'package:ulicastefankowa/shared/storage/settings_bloc.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/ui/debounce_widget.dart';
import 'package:ulicastefankowa/shared/ui/fade_in.dart';
import 'package:ulicastefankowa/shared/ui/photo_hero.dart';
import 'package:ulicastefankowa/shared/ui/themed_image.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';

const double _kFlexibleSpaceMaxHeight = 230;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.onPageChanged,
  }) : super(key: key);

  final ValueChanged<AppRoutePath> onPageChanged;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

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
                  ThemedImage(
                    child: Image.asset(
                      'images/header.jpg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      height: _kFlexibleSpaceMaxHeight,
                    ),
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
                      childCount: data.length,
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
