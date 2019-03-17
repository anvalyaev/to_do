import 'package:flutter/material.dart';
import '../bloc_presenters/index.dart' as bloc_presenters;
import '../bloc_presenters/bloc_presenter_provider.dart';

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc_presenters.Initial bloc = BlocPresenterProvider.of<bloc_presenters.Initial>(context);

    return Scaffold(
      body: Center(
        child: Icon(Icons.check_box, size: 60),
      )
    );
  }
}