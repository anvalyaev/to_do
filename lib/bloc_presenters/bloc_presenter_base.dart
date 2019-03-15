import 'dart:async';
import '../interactor/accessor_controller.dart';
import '../interactor/actions/action_base.dart';
import '../interactor/notifications/notification_base.dart';

abstract class BlocPresenterBase {
  AccessorController _controller = new AccessorController();
  List<StreamSubscription> _subscriptions = [];
  Set<int> _myNotifications = {};
  Set<int> _myActions = {};
  Set<Output> _properties = new Set<Output>();
  Set<Input> _inputs = new Set<Input>();

  BlocPresenterBase() {
    print("New bloc presenter: $runtimeType");
  }
  Future<T> execute<T extends ActionBase>(T action) {
    bool isMyAction(ActionBase action) {
      return _myActions.contains(action.id);
    }

    Future<T> streamHandler() async {
      T res;
      await for (T value in _controller.actionStream.where(isMyAction)) {
        res = value;
        _myActions.remove(value.id);
      }
      return res;
    }
    _controller.addAction(action);
    return streamHandler();
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
    _myNotifications.clear();

    for (Output property in _properties) {
      property.dispose();
    }

    for (Input input in _inputs) {
      input.dispose();
    }
    _myNotifications.clear();
  }
}

class Output<T> {
  T _value;
  StreamController<T> _controller = StreamController<T>();

  Output.of(BlocPresenterBase bloc_presenter, T initial) {
    value = initial;
    bloc_presenter._properties.add(this);
  }
  set value(T v) {
    _value = v;
    _controller.sink.add(_value);
  }

  T get value => _value;
  Stream<T> get stream => _controller.stream;
  void dispose() {
    _controller.close();
  }
}

class Input<T> {
  StreamController<T> _controller = StreamController<T>();
  Input.of(BlocPresenterBase bloc_presenter, {void handler(T data)}) {
    if (handler != null) addHandler(handler);
    bloc_presenter._inputs.add(this);
  }
  void addHandler(void handler(data)) {
    _controller.stream.listen(handler);
  }

  void handle(T data) => _controller.sink.add(data);
  void dispose() {
    _controller.close();
  }
}
