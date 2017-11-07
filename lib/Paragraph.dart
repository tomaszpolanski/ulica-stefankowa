class Paragraph {
  Paragraph({this.text, this.spans});

  String text;
  List<ProperSpan> spans;
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