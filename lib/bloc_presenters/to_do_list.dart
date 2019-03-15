import 'package:flutter/material.dart';
import 'bloc_presenter_base.dart';
import '../interactor/actions/to_do.dart' as actions;
import '../interactor/notifications/to_do_list_notifier.dart' as notifications;
import '../interactor/notifications/notification_base.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';

class ChangeStatusItemData {
  ChangeStatusItemData(this.id, this.done);
  final String id;
  final bool done;
}

class ShowEditItemData {
  ShowEditItemData(this.id, this.context);
  final String id;
  final BuildContext context;
}

class ToDoList extends BlocPresenterBase {
  Output<List<ToDoItem>> list;
  Input<String> removeItem;
  Input<ChangeStatusItemData> changeStatusItem;
  Input<BuildContext> showCreateItem;
  Input<ShowEditItemData> showEditItem;

  ToDoList() {
    list = Output.of(this, []);
    removeItem = Input.of(this, handler: (data) {
      execute(actions.RemoveToDoItem(data)).whenComplete(() {
        print('RemoveToDoItem compleated');
      });
    });
    changeStatusItem = Input.of(this, handler: (data) {
      execute(actions.EditToDoItem(data.id, done: data.done)).whenComplete(() {
        print('EditToDoItem compleated');
      });
    });
    showEditItem = Input.of(this, handler: (data) {
      Navigator.of(data.context).pushNamed('/Main/ToDoList/ToDoEdit', arguments: data.id);
    });
    showCreateItem = Input.of(this, handler: (data) {
      Navigator.of(data).pushNamed('/Main/ToDoList/ToDoCreate');
    });

    subscribeTo(notifications.ToDoListNotifier(),
        (NotificationBase notification) {
      notifications.ToDoListNotifier notificationRes =
          notification as notifications.ToDoListNotifier;
      list.value = notificationRes.data;
    });
  }
}
