import "dart:async";
import 'accessor.dart';
import 'entities/index.dart' as entities;
import 'data_stores/index.dart' as data_stores;
import 'actions/action_base.dart';
import 'notifications/notification_base.dart';
import 'data_stores/index.dart' as data_stores;

class AccessorDummy implements IAccessor {
  List<entities.EntityBase> _activeModels = [];
  Map<NotificationBase, Function> _notifications = {};
  StreamController<entities.EntityBase> _controller =
      StreamController<entities.EntityBase>.broadcast();

  entities.IAccount _account;
  entities.IToDoList _toDoList;
  data_stores.IDatabase _database;
  data_stores.IDatabase get database {
    if (_database == null) {
      _database = new data_stores.DatabaseDummy();
    }
    return _database;
  }

  entities.IAccount get account {
    if (_account == null) {
      _account = new entities.Account(_controller, database);
      _activeModels.add(_account);
    }
    return _account;
  }

  entities.IToDoList get toDoList {
    if (_toDoList == null) {
      _toDoList = new entities.ToDoList(_controller);
      _activeModels.add(_toDoList);
    }
    return _toDoList;
  }

  AccessorDummy() {
    _controller.stream.listen((entities.EntityBase entity) {
      _notifications
          .forEach((NotificationBase notification, Function function) {
        _testNotification(notification, entity);
      });
    });
  }

  void initialize() {}

  Future<ActionBase> runAction(ActionBase action) async {
    Completer<ActionBase> c = new Completer();

    action.doAction(this, (ActionBase result) {
      c.complete(result);
    });
    return c.future;
  }

  void addNotification(
      NotificationBase notification, void onNotify(NotificationBase result)) {
    _notifications[notification] = onNotify;
    _testNotificationOnActiveModels(notification);
  }

  void removeNotification(int id) {
    _notifications.removeWhere((item, func) {
      return item.id == id;
    });
  }

  void _testNotification(
      NotificationBase notification, entities.EntityBase entity) {
    if (notification.whenNotify(entity)) {
      notification.grabData(entity);
      _notifications[notification](notification);
    }
  }

  void _testNotificationOnActiveModels(NotificationBase notification) {
    if (_activeModels.isEmpty) return;
    for (entities.EntityBase entity in _activeModels) {
      _testNotification(notification, entity);
    }
  }
}
