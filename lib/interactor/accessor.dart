import "dart:async";
import 'dart:isolate';
import 'package:gate/gate.dart';
import 'entities/index.dart' as entities;
import 'data_stores/index.dart' as data_stores;

import 'actions/action_base.dart';
import 'notifications/notification_base.dart';
export 'data_stores/index.dart';
export 'entities/index.dart';

abstract class IAccessor {
  data_stores.IDatabase get database;
  entities.IAccount get account;
  entities.IToDoList get toDoList;

  void initialize();

  // void _runAction(ActionBase action);
  // void _testNotification(NotificationBase notification, entities.EntityBase entity);
}

class Accessor extends Worker implements IAccessor {
  data_stores.IDatabase _database;
  entities.IAccount _account;
  entities.IToDoList _toDoList;
  List<entities.EntityBase> _activeModels = [];
  List<NotificationBase> _notifications = [];
  StreamController<entities.EntityBase> _controller =
      StreamController<entities.EntityBase>.broadcast(onListen: () {
    print("Interactor: LISTEN");
  }, onCancel: () {
    print("Interactor: CANCEL");
  });
  Map<String, dynamic> mainThreadData;

  Accessor(SendPort sendPort) : super(sendPort);

  data_stores.IDatabase get database {
    if (_database == null) {
      _database = new data_stores.SembastDataBase();
    }
    return _database;
  }

  entities.IAccount get account {
    if (_account == null) {
      _account = new entities.Account(_controller, database);
    }
    return _account;
  }

  entities.IToDoList get toDoList {
    if (_toDoList == null) {
      _toDoList = new entities.ToDoList(_controller);
    }
    return _toDoList;
  }

  void initialize() async {
    data_stores.SembastToDoItemRepository repo =
        new data_stores.SembastToDoItemRepository(_database);
    List<data_stores.ToDoItem> list = await repo.getAll();
    toDoList.reset(items: list);
  }

  onNewMessage(dynamic data) {
    print("New message from controller: $data");
    if (data is NotificationBase) {
      _notifications.add(data);
      _testNotificationOnActiveModels(data);
    } else if (data is ActionBase) {
      ActionBase action = data;
      _runAction(action);
    } else if (data is int) {
      int notificationId = data;
      _notifications.removeWhere((item) {
        return item.id == notificationId;
      });
    }
  }

  onWork() {
    _controller.stream.listen((entities.EntityBase entity) {
      for (NotificationBase notification in _notifications) {
        _testNotification(notification, entity);
      }
    });
  }

  void _testNotification(
      NotificationBase notification, entities.EntityBase entity) {
    if (notification.whenNotify(entity)) {
      notification.grabData(entity);
      send(notification);
    }
  }

  void _runAction(ActionBase action){
          action.doAction(this, (ActionBase result) {
        send(result);
      }); 
  }

  void _testNotificationOnActiveModels(NotificationBase notification) {
    if (_activeModels.isEmpty) return;
    for (entities.EntityBase entity in _activeModels) {
      _testNotification(notification, entity);
    }
  }
}
