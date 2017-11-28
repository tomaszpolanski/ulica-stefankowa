import 'package:meta/meta.dart';
import 'package:ulicastefankowa/network/Prismic.dart';


typedef Prismic PrismicFun();

class Injector {
  static final Injector _singleton = new Injector._internal();
  static PrismicFun _prismicFun;
  static Prismic _prismic;

  static void bind({ @required Prismic prismic()}) {
    assert(prismic != null);
    _prismicFun = prismic;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  Prismic get prismic {
    if (_prismic == null) {
      _prismic = _prismicFun();
    }
    return _prismic;
  }
}
