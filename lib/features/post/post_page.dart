import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ulicastefankowa/features/post/paragraph.dart';
import 'package:ulicastefankowa/features/post/post.dart';
import 'package:ulicastefankowa/shared/theme/app_text_theme.dart';
import 'package:ulicastefankowa/shared/ui/photo_hero.dart';
import 'package:ulicastefankowa/shared/utils/text_utils.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    Key key,
    this.post,
    this.useLightTheme,
    @required this.onThemeChanged,
    this.textScale,
  })  : assert(onThemeChanged != null),
        super(key: key);

  final Post post;
  final bool useLightTheme;
  final ValueChanged<bool> onThemeChanged;

  final double textScale;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with TickerProviderStateMixin {
  TextStyle _getStyle(String type, {@required TextStyle style}) {
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

  TextSpan _getSpan(ProperSpan span, {@required TextStyle style}) {
    return TextSpan(text: span.text, style: _getStyle(span.type, style: style));
  }

  List<Widget> _getWidgets() {
    final style = AppTextTheme.of(context).post;
    List<Widget> content = [
      Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: PhotoHero(
          photo: widget.post.imageUrl,
          onTap: () => Navigator.of(context).pop(),
        ),
      )
    ];
    content.addAll(
      widget.post.text.map((it) => it is TextParagraph
          ? _buildTextParagraphs(
              it.spans.map((span) => _getSpan(span, style: style)))
          : it is ImageParagraph
              ? _buildImageParagraphs(it.url)
              : const SizedBox()),
    );
    return content;
  }

  Widget _buildTextParagraphs(Iterable<TextSpan> spans) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: spans.toList(),
        ),
      ),
    );
  }

  Widget _buildImageParagraphs(String image) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FadeInImage.assetNetwork(
        image: image,
        placeholder: 'images/header.jpg',
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          SliverList(delegate: SliverChildListDelegate(_getWidgets())),
        ],
      ),
    );
  }
}
