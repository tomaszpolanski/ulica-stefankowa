// ignore: import_of_legacy_library_into_null_safe
import 'package:flusmic/flusmic.dart';
import 'package:ulicastefankowa/features/post/post.dart';
import 'package:ulicastefankowa/shared/security/environment.dart';

const String _kEndpoint = 'https://ulicastefankowa.prismic.io/api/v2';

abstract class Prismic {
  Future<List<BasicPost>> fetchPosts();

  Future<DetailPost> fetchPostDetails(String id);
}

class PrismicImpl extends Prismic {
  PrismicImpl(Env environment)
      : flusmic = Flusmic(
          prismicEndpoint: _kEndpoint,
          defaultAuthToken: environment.prismic,
        );

  final Flusmic flusmic;

  @override
  Future<List<BasicPost>> fetchPosts() async {
    final response = await flusmic.query([], fetch: [
      CustomPredicatePath('post', 'id', fetch: true),
      CustomPredicatePath('post', 'title', fetch: true),
      CustomPredicatePath('post', 'image', fetch: true),
    ]);
    return response.results.map((e) => BasicPost.fromJson(e)).toList();
  }

  @override
  Future<DetailPost> fetchPostDetails(String id) async {
    final response = await flusmic.getDocumentById(id);
    return DetailPost.fromJson(response.results.single.data);
  }
}
