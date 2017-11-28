import './Paragraph.dart';

class Post {
  Post({this.title, this.imageUrl, this.description, this.text});

  final String title;
  final String imageUrl;
  final String description;
  final List<Paragraph> text;
}
