import 'package:ulicastefankowa/features/post/paragraph.dart';

class Post {
  Post({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.text,
  });

  final String title;
  final String imageUrl;
  final String description;
  final List<Paragraph> text;
}
