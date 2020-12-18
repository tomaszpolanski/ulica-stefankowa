import 'package:flutter/material.dart';

/// Performers fade in transition whenever the widget is displayed
class FadeInWidget extends StatefulWidget {
  const FadeInWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeIn)),
      child: widget.child,
    );
  }
}

class SliverFadeInWidget extends StatefulWidget {
  const SliverFadeInWidget({
    Key? key,
    required this.sliver,
  }) : super(key: key);

  final Widget sliver;

  @override
  _SliverFadeInWidgetState createState() => _SliverFadeInWidgetState();
}

class _SliverFadeInWidgetState extends State<SliverFadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeIn)),
      sliver: widget.sliver,
    );
  }
}
