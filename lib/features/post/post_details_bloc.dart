import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulicastefankowa/features/post/post.dart';
import 'package:ulicastefankowa/shared/network/prismic.dart';
import 'package:ulicastefankowa/shared/state/state.dart';

abstract class _PostDetailsEvent {}

class _Fetch implements _PostDetailsEvent {
  const _Fetch(this.id);

  final String id;
}

class PostDetailsBloc extends Bloc<_PostDetailsEvent, PostDetailsState> {
  PostDetailsBloc(this.provider) : super(const PostDetailsState());

  final Prismic provider;

  void fetch(String id) => add(_Fetch(id));

  @override
  Stream<PostDetailsState> mapEventToState(_PostDetailsEvent event) async* {
    if (event is _Fetch) {
      try {
        yield const PostDetailsState(loading: true);
        final post = await provider.fetchPostDetails(event.id);
        yield PostDetailsState(data: post);
      } catch (e) {
        yield PostDetailsState(error: e);
      }
    }
  }
}

class PostDetailsState implements BaseState<DetailPost> {
  const PostDetailsState({
    this.data,
    this.error,
    this.loading = false,
  });

  @override
  final DetailPost? data;

  @override
  final Object? error;

  @override
  final bool loading;
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
