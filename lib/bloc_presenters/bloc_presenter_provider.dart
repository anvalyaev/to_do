import 'package:flutter/material.dart';
import 'bloc_presenter_base.dart';

class BlocPresenterProvider<T extends BlocPresenterBase>
    extends StatefulWidget {
  BlocPresenterProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocPresenterBase>(BuildContext context) {
    final type = _typeOf<BlocPresenterProvider<T>>();
    BlocPresenterProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T>
    extends State<BlocPresenterProvider<BlocPresenterBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.doInitiate(context);
    return widget.child;
  }
}