import 'package:flutter/material.dart';
import 'bloc_presenter_base.dart';

T provider<T extends BlocPresenterBase>() {}

class BlocPresenterProvider<T extends BlocPresenterBase>
    extends StatefulWidget {
  BlocPresenterProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    @required this.route,
    @required this.onDispose,
  }) : super(key: key);

  final T bloc;
  final Widget child;
  final String route;
  final Function onDispose;
  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>(route, onDispose);

  static T of<T extends BlocPresenterBase>(BuildContext context) {
    final type = _typeOf<BlocPresenterProvider<T>>();
    BlocPresenterProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T>
    extends State<BlocPresenterProvider<BlocPresenterBase>> {
  final String route;
  final Function onDispose;

  _BlocProviderState(this.route, this.onDispose);
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
    onDispose(route);
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.doInitiate(context);
    return widget.child;
  }
}
