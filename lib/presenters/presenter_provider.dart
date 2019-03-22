import 'package:flutter/material.dart';
import 'presenter_base.dart';

T provider<T extends PresenterBase>() {}

class PresenterProvider<T extends PresenterBase>
    extends StatefulWidget {
  PresenterProvider({
    Key key,
    @required this.child,
    @required this.presenter,
    this.route,
    this.onDispose,
  }) : super(key: key);

  final T presenter;
  final Widget child;
  final String route;
  final Function onDispose;
  @override
  _ProviderState<T> createState() =>
      _ProviderState<T>(route, onDispose);

  static T of<T extends PresenterBase>(BuildContext context) {
    final type = _typeOf<PresenterProvider<T>>();
    PresenterProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.presenter;
  }

  static Type _typeOf<T>() => T;
}

class _ProviderState<T>
    extends State<PresenterProvider<PresenterBase>> {
  final String route;
  final Function onDispose;

  _ProviderState(this.route, this.onDispose);
  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
    if ((route != null) && (onDispose != null)) {
      onDispose(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.presenter.doInitiate(context);
    return widget.child;
  }
}
