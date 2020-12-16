import 'package:flutter/material.dart';
import 'package:ulicastefankowa/features/post/paragraph.dart';
import 'package:ulicastefankowa/features/post/post.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/ui/photo_hero.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    Key? key,
    required this.post,
    required this.useLightTheme,
    required this.onThemeChanged,
    required this.textScale,
  }) : super(key: key);

  final Post post;
  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double textScale;

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
    final style = AppTextTheme.of(context).post;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            title: StefanText(
              widget.post.title,
              style: AppTextTheme.of(context).s1,
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () => widget.onThemeChanged(!widget.useLightTheme),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PhotoHero(
                photo: widget.post.imageUrl,
                onTap: () => Navigator.of(context)?.pop(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, int index) {
                final paragraph = widget.post.text[index];
                if (paragraph is TextParagraph) {
                  return TextParagraphWidget(
                    paragraph.spans
                        .map((span) => _getSpan(span, style: style))
                        .toList(growable: false),
                  );
                } else if (paragraph is ImageParagraph) {
                  return ImageParagraphWidget(paragraph.url);
                }
                return null;
              },
              childCount: widget.post.text.length,
            ),
          ),
        ],
      ),
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
