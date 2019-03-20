import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'bloc_presenter_base.dart';
import '../interactor/actions/initial_storage.dart' as actions;

class Initial extends BlocPresenterBase {
  @override
  void initiate(BuildContext context) {
    print("void initiate(BuildContext context)");
    getApplicationDocumentsDirectory().then((Directory dir){
      execute<actions.InitialStorage>(actions.InitialStorage(dir.path)).whenComplete((){
        Navigator.of(context).pushReplacementNamed('/Main/ToDoList');
      });
    });
    
  }
}
