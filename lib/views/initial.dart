import 'package:flutter/material.dart';
import '../presenters/initial.dart' as bloc_presenters;
import '../presenters/presenter_provider.dart';

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc_presenters.Initial bloc = PresenterProvider.of<bloc_presenters.Initial>(context);

    return Scaffold(
      body: Center(
        child: Icon(Icons.check_box, size: 60),
      )
    );
  }
}