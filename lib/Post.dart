
import './Paragraph.dart';

class Post {
  Post({this.title, this.imageUrl, this.description, this.text});

  String title;
  String imageUrl;
  String description;
  List<Paragraph> text;
}