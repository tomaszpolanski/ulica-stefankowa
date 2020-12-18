import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulicastefankowa/features/post/post.dart';
import 'package:ulicastefankowa/shared/network/prismic.dart';
import 'package:ulicastefankowa/shared/state/state.dart';

abstract class _HomeEvent {}

class _FetchPosts implements _HomeEvent {
  const _FetchPosts();
}

class HomeBloc extends Bloc<_HomeEvent, HomeState> {
  HomeBloc(this.provider) : super(const HomeState());

  final Prismic provider;

  void fetch() => add(const _FetchPosts());

  @override
  Stream<HomeState> mapEventToState(_HomeEvent event) async* {
    if (event is _FetchPosts) {
      try {
        yield const HomeState(loading: true);
        final posts = await provider.fetchPosts();
        yield HomeState(data: posts);
      } catch (e) {
        yield HomeState(error: e);
      }
    }
  }
}

class HomeState implements BaseState<List<BasicPost>> {
  const HomeState({
    this.data,
    this.error,
    this.loading = false,
  });

  @override
  final List<BasicPost>? data;

  @override
  final Object? error;

  @override
  final bool loading;
}
