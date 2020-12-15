abstract class Paragraph {}

class TextParagraph extends Paragraph {
  TextParagraph({this.text, this.spans});

  String text;
  List<ProperSpan> spans;
}

class ImageParagraph extends Paragraph {
  ImageParagraph({this.url});

  String url;
}

class Span {
  Span({this.start, this.end, this.type});

  num start;
  num end;
  String type;
}

class ProperSpan {
  ProperSpan({this.text, this.type});

  String text;
  String type;
}
