import 'dart:async';
import 'package:flutter/material.dart';
import '../interactor/accessor_controller.dart';
import '../interactor/actions/action_base.dart';
import '../interactor/notifications/notification_base.dart';

abstract class StreamConstructor<T, B extends BlocPresenterBase> {
  B bloc;
  Stream<T> stream;
  T current;
  StreamConstructor(this.bloc){
    stream = _constructStream();
  }
  Stream<T> _constructStream();
}

abstract class BaseBlocEvent {
  BaseBlocEvent(this.isUserEvent);
  final bool isUserEvent;
}

abstract class BlocPresenterBase<T extends BaseBlocEvent> {
  AccessorController _controller = new AccessorController();

  List<StreamSubscription> _subscriptions = [];
  StreamController<T> _eventsStreamController = StreamController.broadcast();
  StreamSink get events => _eventsStreamController.sink;
  Stream<T> get streamEvents => _eventsStreamController.stream;

  Set<int> _myNotifications = {};
  Set<int> _myActions = {};
  bool initiated = false;

  BlocPresenterBase() {
    print("New bloc presenter: $runtimeType");
  }
  void doInitiate(BuildContext context) {
    if (initiated) return;
    initiate(context);
    initiated = true;
  }

  void initiate(BuildContext context);
  void addUserInputHandler<E extends T>(void handler(E event)) {
    streamEvents
        .where((event) => (event is E) && (event.isUserEvent))
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

  void subscribeTo(NotificationBase notification,
      void onNotify(NotificationBase notification)) {
    bool isMyNotification(NotificationBase notification) {
      return _myNotifications.contains(notification.id);
    }

    _myNotifications.add(notification.id);
    _subscriptions.add(_controller.notificationStream
        .where(isMyNotification)
        .listen(onNotify));
    _controller.addNotification(notification);
  }

  void dispose() {
    print("Dispose bloc presenter: $runtimeType");
    for (StreamSubscription subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    for (int notificationId in _myNotifications) {
      _controller.removeNotification(notificationId);
    }
    _eventsStreamController.close();
    _myNotifications.clear();
    _myNotifications.clear();
    initiated = false;
  }
}
