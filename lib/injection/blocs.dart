import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulicastefankowa/injection/injector.dart';
import 'package:ulicastefankowa/shared/storage/settings_bloc.dart';

class BlockInjection extends StatelessWidget {
  const BlockInjection(
    this.injector, {
    required this.child,
    Key? key,
  }) : super(key: key);

  final Injector injector;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => SettingsBloc(injector.settings),
        ),
      ],
      child: child,
    );
  }
}
