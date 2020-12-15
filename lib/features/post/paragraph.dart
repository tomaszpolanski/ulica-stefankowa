abstract class Paragraph {}

class TextParagraph extends Paragraph {
  TextParagraph({
    required this.text,
    required this.spans,
  });

  String text;
  List<ProperSpan> spans;
}

class ImageParagraph extends Paragraph {
  ImageParagraph({required this.url});

  String url;
}

class Span {
  Span({
    required this.start,
    required this.end,
    required this.type,
  });

  int start;
  int end;
  String type;
}

class ProperSpan {
  ProperSpan({required this.text, required this.type});

  String text;
  String type;
}
