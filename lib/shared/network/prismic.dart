// ignore: import_of_legacy_library_into_null_safe
import 'package:flusmic/flusmic.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';

const String _kEndpoint = 'https://ulicastefankowa.prismic.io/api/v2';

// ignore: one_member_abstracts
abstract class Prismic {
  Future<List<Map<String, dynamic>>> getPosts();
}

class PrismicImpl extends Prismic {
  PrismicImpl(Env environment)
      : flusmic = Flusmic(
          prismicEndpoint: _kEndpoint,
          defaultAuthToken: environment.prismic,
        );

  final Flusmic flusmic;

  @override
  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await flusmic.getRootDocument();
    return response.results.map((e) => e.data).toList();
  }
}
