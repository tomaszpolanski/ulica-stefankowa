import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseState<T> {
  T? get data;

  Object? get error;

  bool get loading;
}

class AppBlocBuilder<T extends Cubit<S>, S> extends StatefulWidget {
  const AppBlocBuilder({
    required this.builder,
    this.onInit,
    Key? key,
  }) : super(key: key);

  final void Function(BuildContext context)? onInit;
  final BlocWidgetBuilder<S> builder;

  @override
  _AppBlocBuilderState<T, S> createState() => _AppBlocBuilderState();
}

class _AppBlocBuilderState<T extends Cubit<S>, S>
    extends State<AppBlocBuilder<T, S>> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      _initialized = true;
      final onInit = widget.onInit;
      if (onInit != null) {
        onInit(context);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, S>(
      builder: widget.builder,
    );
  }
}
