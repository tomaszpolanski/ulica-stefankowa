abstract class Env {
  String get prismic;
}

class EnvImpl implements Env {
  @override
  String get prismic => const String.fromEnvironment('STEFAN_PRISMIC');
}
