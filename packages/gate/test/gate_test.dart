// import 'package:flutter_test/flutter_test.dart';

// import 'package:gate/gate.dart';
// import 'dart:async';
// import 'dart:isolate';

// class ConcreteController extends Controller{

//   void onNewMessage(dynamic data){
//     print("New message from worker: $data");
//   }

//   void onError(dynamic err){
//     print("Error: $err");
//   }

//   void onStateChanged(ControllerState state){
//     print("New controller state: $state");

//     if(state == ControllerState.initialized){
//       new Timer(Duration(seconds: 2), (){
//         print("Send to worker...");
//         send("I am $runtimeType");
//       });
//     }
//   }
//   static void work(SaendPort sendPort){
//     new ConcreteWorker(sendPort).work();
//   }
// }

// class ConcreteWorker extends Worker{

//   ConcreteWorker(SendPort sendPort) : super(sendPort);
//   void onNewMessage(dynamic data){
//     print("New message from controller: $runtimeType, $data");
//   }

//   void onWork(){
//     new Timer(Duration(seconds: 1), (){
//       print("Send to worker...");
//       send("I am $runtimeType");
//     });
//   }
// }

// class TestData{

//   int conter = 0;
//   String name = "Name";
// }


// main(){
//   ConcreteController controller = new ConcreteController();
//   controller.startWorking(ConcreteController.work);
// }
