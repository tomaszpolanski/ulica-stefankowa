import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';

class DebounceWidget<T> extends StatefulWidget {
  const DebounceWidget({
    Key? key,
    required this.builder,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  final Widget Function(BuildContext context, T value, ValueSetter<T> onChanged)
      builder;
  final ValueSetter<T> onChanged;
  final T value;

  @override
  _DebounceWidgetState<T> createState() => _DebounceWidgetState();
}

class _DebounceWidgetState<T> extends State<DebounceWidget<T>> {
  final PublishSubject<T> _subject = PublishSubject();
  late StreamSubscription<T> _subscription;
  late T _current;

  @override
  void initState() {
    _current = widget.value;
    _subscription = _subject.stream
        .debounce((_) => TimerStream(true, const Duration(seconds: 1)))
        .listen(widget.onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _current,
      (value) {
        _subject.add(value);
        setState(() {
          _current = value;
        });
      },
    );
  }
}
