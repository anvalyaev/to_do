import 'dart:async';
import 'package:flutter/material.dart';
import '../interactor/accessor_controller.dart';
import '../interactor/actions/action_base.dart';
import '../interactor/notifications/notification_base.dart';


abstract class BaseInputEvent {
  BaseInputEvent();
}

abstract class PresenterBase<T extends BaseInputEvent> {
  AccessorController _controller = new AccessorController();

  StreamController<T> _eventsStreamController = StreamController.broadcast();
  StreamSink get events => _eventsStreamController.sink;

  Set<int> _myNotifications = {};
  Set<int> _myActions = {};
  bool initiated = false;

  PresenterBase() {
    print("New bloc presenter: $runtimeType");
  }
  void doInitiate(BuildContext context) {
    if (initiated) return;
    initiate(context);
    initiated = true;
  }

  void initiate(BuildContext context);
  void addInputEventHandler<E extends T>(void handler(E event)) {
    _eventsStreamController.stream
        .where((event) => (event is E)).cast<E>()
        .listen(handler);
  }

  Future<T> execute<T extends ActionBase>(T action) async {
    T actionRes;
    _myActions.add(action.id);
    _controller.addAction(action);

    print("Execute start: ${action.id}");

    await _controller.actionStream.any((ActionBase action) {
      bool res = _myActions.contains(action.id);
      if (res) {
        _myActions.remove(action.id);
        actionRes = action as T;
      }
      return res;
    });
    return actionRes;
  }

  Stream<T> subscribeTo<T extends NotificationBase>(T notification) {
    _myNotifications.add(notification.id);
    _controller.addNotification(notification);
    return _controller.notificationStream.where((notification) => _myNotifications.contains(notification.id)).cast<T>();
  }

  void dispose() {
    print("Dispose bloc presenter: $runtimeType");

    for (int notificationId in _myNotifications) {
      _controller.removeNotification(notificationId);
    }
    _eventsStreamController.close();
    _myNotifications.clear();
    initiated = false;
  }
}
