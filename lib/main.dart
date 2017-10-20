import 'package:flutter/material.dart';


const double _kFlexibleSpaceMaxHeight = 180.0;

const List<Color> _kTitleColors = const <Color>[
  const Color(0xffef9c20),
  const Color(0xff35c4d5),
  const Color(0xff3c8bac),
  const Color(0xffef9ecc),
  const Color(0xff51ba50),
];

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new MyHomePage(title: 'Ulica Stefankowa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();


  List<Widget> buildItem() {
    return _kTitleColors.map((color) =>
    new Container(
      height: 150.0,
      color: color,
    )).toList();
  }

  Widget buildTitle(String title, List<Color> colors) {
    var list = new List<Widget>();
    for (var i = 0; i < title.length; i++) {
      final letter = new String.fromCharCode(title.codeUnitAt(i));
      list.add(new Text(letter,
        style: new TextStyle(
          color: colors[i % colors.length],
        ),
      ));
    }
    return new Row(
      children: list,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: _kFlexibleSpaceMaxHeight,
              flexibleSpace: new FlexibleSpaceBar(
                title: buildTitle(
                    "Ulica Stefankowa", _kTitleColors),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.asset(
                      'images/header.jpg',
                      fit: BoxFit.cover,
                      height: _kFlexibleSpaceMaxHeight,
                    ),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [.7,  1.0],
                          colors: const <Color>[
                            const Color(0x00000000), const Color(0x60FF5722)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverList(
                delegate: new SliverChildListDelegate(buildItem())
            ),
          ],
        )
    );
  }
}
