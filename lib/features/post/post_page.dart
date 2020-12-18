import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulicastefankowa/features/post/paragraph.dart';
import 'package:ulicastefankowa/features/post/post_details_bloc.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/storage/settings.dart';
import 'package:ulicastefankowa/shared/storage/settings_bloc.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/ui/photo_hero.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';

class PostRouterPage extends Page<void> {
  PostRouterPage(this.id) : super(key: ValueKey(id));

  final String id;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => PostPage(postId: id),
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  final String postId;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with TickerProviderStateMixin {
  TextStyle _getStyle(String? type, {required TextStyle style}) {
    switch (type) {
      case 'strong':
        return style.copyWith(fontWeight: FontWeight.bold);
      case 'em':
        return style.copyWith(fontStyle: FontStyle.italic);
      case 'normal':
      default:
        return style;
    }
  }

  TextSpan _getSpan(ProperSpan span, {required TextStyle style}) {
    return TextSpan(text: span.text, style: _getStyle(span.type, style: style));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      future: Injection.of(context)!.prismic.fetchPostDetails(widget.postId),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data != null) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  title: StefanText(
                    data.title,
                    style: AppTextTheme.of(context).s1,
                  ),
                  actions: <Widget>[
                    BlocBuilder<SettingsBloc, Settings>(
                      builder: (context, settings) => IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          BlocProvider.of<SettingsBloc>(context).save(
                            settings.copyWith(
                              useLightTheme: !settings.useLightTheme,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PhotoHero(
                      photo: data.imageUrl,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                BlocBuilder<SettingsBloc, Settings>(
                  builder: (context, settings) {
                    final style = AppTextTheme.of(context).post.copyWith(
                          fontSize: settings.textSize,
                        );
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, int index) {
                          final paragraph = data.text[index];
                          if (paragraph is TextParagraph) {
                            return Align(
                              child: SizedBox(
                                width: 720,
                                child: TextParagraphWidget(
                                  paragraph.spans
                                      .map((span) =>
                                          _getSpan(span, style: style))
                                      .toList(growable: false),
                                ),
                              ),
                            );
                          } else if (paragraph is ImageParagraph) {
                            return Align(
                              child: SizedBox(
                                width: 720,
                                child: ImageParagraphWidget(paragraph.url),
                              ),
                            );
                          }
                          return null;
                        },
                        childCount: data.text.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class TextParagraphWidget extends StatelessWidget {
  const TextParagraphWidget(this.spans, {Key? key}) : super(key: key);

  final List<TextSpan> spans;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: spans,
        ),
      ),
    );
  }
}

class ImageParagraphWidget extends StatelessWidget {
  const ImageParagraphWidget(this.image, {Key? key}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FadeInImage.assetNetwork(
        image: image,
        placeholder: 'images/header.jpg',
        fit: BoxFit.contain,
      ),
    );
  }
}
