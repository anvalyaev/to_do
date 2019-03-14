import 'dart:isolate';
import 'abstractgate.dart';

abstract class Worker extends Gate{
  Worker(SendPort val){
    sendPort = val;
  }
  void onWork();
  void work(){
    send(receivePort.sendPort);
    onWork();
  }
}