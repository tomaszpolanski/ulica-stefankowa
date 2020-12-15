abstract class Env {
  String get prismic;
}

class EnvImpl implements Env {
  @override
  String get prismic {
    const prismic = String.fromEnvironment('STEFAN_PRISMIC');
    if (prismic.isEmpty) {
      throw AssertionError(
          'STEFAN_PRISMIC environment variable is not provided. '
          'Please provide access token from https://ulicastefankowa.prismic.io/settings/apps/');
    }
    return prismic;
  }
}
