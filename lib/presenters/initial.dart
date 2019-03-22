import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'presenter_base.dart';
import '../interactor/actions/initial_storage.dart' as actions;

class InitiaEvent extends BaseInputEvent {}

class InitialWireframe extends WireframeBase {
  void showApplication(){
    navigator.pushReplacementNamed('/Main/ToDoList');
  }
}
class Initial extends PresenterBase<InitiaEvent, InitialWireframe> {
  Initial():super(InitialWireframe());
  @override
  void initiate() {
    print("void initiate(BuildContext context)");
    getApplicationDocumentsDirectory().then((Directory dir){
      execute<actions.InitialStorage>(actions.InitialStorage(dir.path)).whenComplete((){
        wireframe.showApplication();
      });
    }); 
  }
}
