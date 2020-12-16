// ignore: import_of_legacy_library_into_null_safe
import 'package:flusmic/flusmic.dart' as prismic;
import 'package:ulicastefankowa/features/post/paragraph.dart';

class BasicPost {
  BasicPost({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory BasicPost.fromJson(prismic.Document json) {
    return BasicPost(
      id: json.id,
      title: json.data['title'].first['text'],
      imageUrl: json.data['image']['url'],
    );
  }

  final String id;
  final String title;
  final String imageUrl;
}

class DetailPost {
  DetailPost({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.text,
  });

  factory DetailPost.fromJson(Map<String, dynamic> json) {
    return DetailPost(
        title: json['title'].first['text'],
        imageUrl: json['image']['url'],
        description: json['description'].first['text'],
        text: json['text']
            .map<Paragraph>(_getParagraph)
            .where((dynamic it) => it != null)
            .toList());
  }

  final String title;
  final String imageUrl;
  final String description;
  final List<Paragraph> text;

  static Paragraph? _getParagraph(dynamic paragraph) {
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

  static Iterable<ProperSpan> _getSpan(List<Span> spans, String text) sync* {
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
}
