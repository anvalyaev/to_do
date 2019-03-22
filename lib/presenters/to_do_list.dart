import 'dart:async';
import 'package:flutter/material.dart';
import 'presenter_base.dart';
import '../interactor/actions/to_do.dart' as actions;
import '../interactor/notifications/to_do_list_notifier.dart' as notifications;
import '../interactor/notifications/notification_base.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';
import '../interactor/entities/to_do_list.dart' as to_do_list;

class ToDoListEvent extends BaseInputEvent {}

class RemoveItem extends ToDoListEvent {
  final String id;
  RemoveItem({@required this.id});
}

class ChangeStatusItem extends ToDoListEvent {
  final String id;
  final bool done;
  ChangeStatusItem({@required this.id, @required this.done});
}

class ShowCreateItem extends ToDoListEvent {
  ShowCreateItem();
}

class ShowEditItem extends ToDoListEvent {
  final String id;
  ShowEditItem({@required this.id});
}

class DeleateAll extends ToDoListEvent {
  DeleateAll();
}

class ChangeFilter extends ToDoListEvent {
  ChangeFilter();
}

class ToDoListReseted extends ToDoListEvent {
  final List<ToDoItem> toDoList;
  ToDoListReseted(this.toDoList);
}

class ToDoListChangeEvent extends ToDoListEvent {
  final to_do_list.LastChange change;
  ToDoListChangeEvent(this.change);
}

enum Filter { all, done, todo }

class ToDoList extends PresenterBase<ToDoListEvent> {
  Stream<notifications.ToDoListNotifier> toDoListNotificationsStream;
  ValueNotifier<Filter> filter = ValueNotifier(Filter.all);
  ValueNotifier<List<ToDoItem>> toDoItems = ValueNotifier([]);

  @override
  void initiate(BuildContext context) {
    toDoListNotificationsStream = subscribeTo(notifications.ToDoListNotifier());
    toDoListNotificationsStream.listen((notification){
      print("Notification: ${notification.change}");
    });
    toDoListNotificationsStream.where((notification) {
      return notification.change.event == to_do_list.Event.add_item;
    }).listen((notification) {
      List<ToDoItem> items = toDoItems.value;
      items.add(notification.change.delta);
      toDoItems.value = items;
      toDoItems.notifyListeners();
    });

    toDoListNotificationsStream.where((notification) {
      return notification.change.event == to_do_list.Event.change_item;
    }).listen((notification) {
      print("before to_do_list.Event.change_item: ${toDoItems.value}, ${toDoItems.hasListeners}");
      int index = toDoItems.value.indexWhere((ToDoItem currentItem) {
        return currentItem.id == notification.change.delta.id;
      });
      toDoItems.value.replaceRange(index, index + 1, [notification.change.delta]);
      print("after to_do_list.Event.change_item: ${toDoItems.value}, ${toDoItems.hasListeners}");
      toDoItems.notifyListeners();
    });

    toDoListNotificationsStream.where((notification) {
      return notification.change.event == to_do_list.Event.remove_all;
    }).listen((notification) {
      toDoItems.value.clear();
      toDoItems.notifyListeners();
    });

    toDoListNotificationsStream.where((notification) {
      return notification.change.event == to_do_list.Event.remove_item;
    }).listen((notification) {
      toDoItems.value.removeWhere((ToDoItem currentItem) {
        bool val = (currentItem.id == notification.change.delta.id);
        return val;
      });
      toDoItems.notifyListeners();
    });

    toDoListNotificationsStream.where((notification) {
      return notification.change.event == to_do_list.Event.reset;
    }).listen((notification) {
      execute(actions.GetToDoList(done: filterDone(filter.value)))
          .then((actions.GetToDoList action) {
        toDoItems.value = action.items;
      });
    });

    addInputEventHandler<ChangeFilter>((event) {
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
        toDoItems.value = action.items;
      });
    });

    addInputEventHandler<RemoveItem>((event) {
      execute(actions.RemoveToDoItem(event.id));
    });

    addInputEventHandler<ChangeStatusItem>((event) {
      execute(actions.EditToDoItem(event.id, done: event.done));
    });

    addInputEventHandler<ShowCreateItem>((event) {
      Navigator.of(context).pushNamed('/Main/ToDoList/ToDoCreate');
    });

    addInputEventHandler<DeleateAll>((event) {
      execute(actions.RemoveAllToDoItem());
    });

    addInputEventHandler<ShowEditItem>((event) {
      Navigator.of(context)
          .pushNamed('/Main/ToDoList/ToDoEdit', arguments: event.id);
    });

    execute(actions.GetToDoList(done: filterDone(filter.value)))
        .then((actions.GetToDoList action) {
      toDoItems.value = action.items;
    });
  }

  bool filterDone(Filter filter) {
    bool res;
    if (filter == Filter.done)
      res = true;
    else if (filter == Filter.todo) res = false;
    return res;
  }
}
