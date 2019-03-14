import 'dart:isolate';

abstract class Gate{
  Gate(){
    _messageWaiting();
  }
  void send(dynamic data){
    if(_sendPort == null) print("ERROR: No out gate port");
    _sendPort.send(data);
  }

  void onNewMessage(dynamic data);
  void onSendPortReceived(SendPort sendPort){}

  ReceivePort get receivePort =>_receivePort;
  set sendPort(SendPort val) => _sendPort = val;



  void _messageWaiting() async{
    await for (dynamic msg in _receivePort) {
      if(msg is SendPort) {
        onSendPortReceived(msg);
      }
      else onNewMessage(msg);
    }
  }

  ReceivePort _receivePort = new ReceivePort();
  SendPort _sendPort;

}