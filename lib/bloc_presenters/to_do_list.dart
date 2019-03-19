import 'package:flutter/material.dart';
import 'bloc_presenter_base.dart';
import '../interactor/actions/to_do.dart' as actions;
import '../interactor/notifications/to_do_list_notifier.dart' as notifications;
import '../interactor/notifications/notification_base.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';
import '../interactor/entities/to_do_list.dart' as to_do_list;

class ChangeStatusItemData {
  ChangeStatusItemData(this.id, this.done);
  final String id;
  final bool done;
}

enum Filter { all, done, todo }

class ToDoList extends BlocPresenterBase {
  Output<List<ToDoItem>> list;
  Output<Filter> filter;
  Input<String> removeItem;
  Input<ChangeStatusItemData> changeStatusItem;
  Input showCreateItem;
  Input<String> showEditItem;
  Input deleateAll;
  Input changeFilter;

  @override
  void initiate(BuildContext context) {
    list = Output.of(this, []);
    filter = Output.of(this, Filter.all);
    removeItem = Input.of(this, handler: (data) {
      execute(actions.RemoveToDoItem(data)).whenComplete(() {
        print('RemoveToDoItem compleated');
      });
    });
    changeStatusItem = Input.of(this, handler: (data) {
      execute(actions.EditToDoItem(data.id, done: data.done)).whenComplete(() {
        bool done;
        if (filter.value == Filter.done)
          done = true;
        else if (filter.value == Filter.todo) done = false;
        execute(actions.GetToDoList(done: done))
            .then((actions.GetToDoList action) {
          list.value = action.items;
        });
      });
    });
    showEditItem = Input.of(this, handler: (data) {
      Navigator.of(context)
          .pushNamed('/Main/ToDoList/ToDoEdit', arguments: data);
    });
    showCreateItem = Input.of(this, handler: (data) {
      Navigator.of(context).pushNamed('/Main/ToDoList/ToDoCreate');
    });

    deleateAll = Input.of(this, handler: (data) {
      execute(actions.RemoveAllToDoItem()).whenComplete(() {
        print('RemoveToDoItem compleated');
      });
    });
    changeFilter = Input.of(this, handler: (data) {
      if (filter.value == Filter.all)
        filter.value = Filter.done;
      else if (filter.value == Filter.done)
        filter.value = Filter.todo;
      else if (filter.value == Filter.todo) filter.value = Filter.all;
      bool done;
      if (filter.value == Filter.done)
        done = true;
      else if (filter.value == Filter.todo) done = false;
      execute(actions.GetToDoList(done: done))
          .then((actions.GetToDoList action) {
        list.value = action.items;
      });
    });
    bool done;
    if (filter.value == Filter.done)
      done = true;
    else if (filter.value == Filter.todo) done = false;
    execute(actions.GetToDoList(done: done)).then((actions.GetToDoList action) {
      list.value = action.items;
    });
    subscribeTo(notifications.ToDoListNotifier(),
        (NotificationBase notification) {
      notifications.ToDoListNotifier notificationRes =
          notification as notifications.ToDoListNotifier;
      to_do_list.LastChange change = notificationRes.data;
      List<ToDoItem> itemList = list.value;
      print("Event: ${change.event}, delta: ${change.delta}");
      switch (change.event) {
        case to_do_list.Event.add_item:
          itemList.add(change.delta);
          break;
        case to_do_list.Event.change_item:
          int index = itemList.indexWhere((ToDoItem currentItem) {
            return currentItem.id == change.delta.id;
          });
          var res = itemList.elementAt(index);
          itemList.replaceRange(index, index + 1, [res]);
          break;
        case to_do_list.Event.remove_all:
          itemList.clear();
          break;
        case to_do_list.Event.remove_item:
          itemList.removeWhere((ToDoItem currentItem) {
            bool val = (currentItem.id == change.delta.id);
            return val;
          });
          break;
        case to_do_list.Event.reset:
          execute(actions.GetToDoList(done: done))
              .then((actions.GetToDoList action) {
            list.value = action.items;
          });
          break;
        default:
      }
      list.value = itemList;
    });
  }
}
