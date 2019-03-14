import 'package:gate/gate.dart';
import 'dart:isolate';
import 'dart:async';
import 'actions/action_base.dart';
import 'notifications/notification_base.dart';
import 'accessor.dart';

class AccessorController extends Controller {

    StreamController<NotificationBase> _controller =
      StreamController<NotificationBase>.broadcast(onListen: () {
    print("InteractorController, notification: LISTEN");
  }, onCancel: () {
    print("InteractorController, notification: CANCEL");
  });

  StreamController<ActionBase> _actionController =
      StreamController<ActionBase>.broadcast(onListen: () {
    print("InteractorController, action: LISTEN");
  }, onCancel: () {
    print("InteractorController, action: CANCEL");
  },);
  List<NotificationBase> _notificationsBuffer = [];
  List<ActionBase> _actionsBuffer = [];
  static final AccessorController _interator =
      new AccessorController._internal();
  AccessorController._internal() {}


  Stream<NotificationBase> get notificationStream => _controller.stream;
  Stream<ActionBase> get actionStream => _actionController.stream;

  void addNotification(NotificationBase notification) {
    if (state == ControllerState.initialized)
      send(notification);
    else
      _notificationsBuffer.add(notification);
  }

  void removeNotification(int notificationId) {
    if (state == ControllerState.initialized) send(notificationId);
  }

  void addAction(ActionBase action) {
    if (state == ControllerState.initialized)
      send(action);
    else
      _actionsBuffer.add(action);
  }

  factory AccessorController() {
    if (_interator.state == ControllerState.uninitialized) {
      _interator.startWorking(work);
    }
    return _interator;
  }
  void onNewMessage(dynamic data) {
    print("New message from interactor: $data");
    if (data is NotificationBase) {
      _controller.sink.add(data);
    } else if (data is ActionBase) {
      _actionController.sink.add(data);
    }
  }

  void onError(dynamic err) {
    print("Error: $err");
  }

  void onStateChanged(ControllerState state) {
    print("New controller state: $state");
    if (state == ControllerState.initialized) {
      if (_notificationsBuffer.isNotEmpty) {
        for (NotificationBase notification in _notificationsBuffer) {
          send(notification);
        }
        _notificationsBuffer.clear();
      }
      if (_actionsBuffer.isNotEmpty) {
        for (ActionBase action in _actionsBuffer) {
          send(action);
        }
        _actionsBuffer.clear();
      }
    }
  }

  static void work(SendPort sendPort) {
    new Accessor(sendPort).work();
  }


}
