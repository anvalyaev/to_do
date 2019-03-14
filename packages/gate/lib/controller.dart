import 'dart:isolate';
import 'abstractgate.dart';

enum ControllerState {
  uninitialized,
  initializing,
  initialized
}

abstract class Controller extends Gate{
  Controller(){
    onStateChanged(state);
  }
  void startWorking(void work(SendPort sendPort))async{
    isolate = await Isolate.spawn(work, receivePort.sendPort);
    state = ControllerState.initializing;
    await for (dynamic err in isolate.errors) {
      onError(err);
    }
  }
  set state(ControllerState val) {
    _state = val;
    onStateChanged(_state);
  }
  ControllerState get state => _state;

  void onError(dynamic err);
  void onStateChanged(ControllerState state);
  void onSendPortReceived(SendPort val){
    sendPort = val;
    state = ControllerState.initialized;
  }

  Isolate isolate;
  ControllerState _state = ControllerState.uninitialized;
}