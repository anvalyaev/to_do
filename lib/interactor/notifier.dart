import 'dart:async';

class Notifier<T> {
  StreamController<T> controller = StreamController<T>.broadcast(
      onListen: (){print("onListen");},
      onCancel: (){print("onCancel");}
      );
  
  void notify(T data){
    controller.sink.add(data);
  }
}