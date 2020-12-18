abstract class BaseState<T> {
  T? get data;

  Object? get error;

  bool get loading;
}
