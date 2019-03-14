import "dart:async";
import 'dart:isolate';
import 'package:gate/gate.dart';
import 'package:sembast/sembast.dart';
import 'entities/index.dart' as entities;
import 'data_stores/index.dart' as data_stores;
import 'actions/action_base.dart';
import 'notifications/notification_base.dart';
export 'data_stores/index.dart';
export 'entities/index.dart';



class Accessor extends Worker {
  data_stores.IDatabase _database;
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

  void initialize() {
  }

  onNewMessage(dynamic data) {
    print("New message from controller: $data");
    if (data is NotificationBase) {
      _notifications.add(data);
      _testNotificationOnActiveModels(data);
    } else if (data is ActionBase) {
      ActionBase action = data;
      action.doAction(this, (ActionBase result) {
        send(result);
      });
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

  void _testNotification(NotificationBase notification, entities.EntityBase entity) {
    if (notification.whenNotify(entity)) {
      notification.grabData(entity);
      send(notification);
    }
  }

  void _testNotificationOnActiveModels(NotificationBase notification) {
    if (_activeModels.isEmpty) return;
    for (entities.EntityBase entity in _activeModels) {
      _testNotification(notification, entity);
    }
  }
}
