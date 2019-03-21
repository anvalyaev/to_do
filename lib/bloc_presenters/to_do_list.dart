import 'dart:async';
import 'package:flutter/material.dart';
import 'bloc_presenter_base.dart';
import '../interactor/actions/to_do.dart' as actions;
import '../interactor/notifications/to_do_list_notifier.dart' as notifications;
import '../interactor/notifications/notification_base.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';
import '../interactor/entities/to_do_list.dart' as to_do_list;

class ToDoListEvent extends BaseBlocEvent {
  ToDoListEvent(bool isUserInput) : super(isUserInput);
}

class RemoveItem extends ToDoListEvent {
  final String id;
  RemoveItem({@required this.id}) : super(true);
}

class ChangeStatusItem extends ToDoListEvent {
  final String id;
  final bool done;
  ChangeStatusItem({@required this.id, @required this.done}) : super(true);
}

class ShowCreateItem extends ToDoListEvent {
  ShowCreateItem() : super(true);
}

class ShowEditItem extends ToDoListEvent {
  final String id;
  ShowEditItem({@required this.id}) : super(true);
}

class DeleateAll extends ToDoListEvent {
  DeleateAll() : super(true);
}

class ChangeFilter extends ToDoListEvent {
  ChangeFilter() : super(true);
}

class ToDoListReseted extends ToDoListEvent {
  final List<ToDoItem> toDoList;
  ToDoListReseted(this.toDoList) : super(false);
}

class ToDoListChangeEvent extends ToDoListEvent {
  final to_do_list.LastChange change;
  ToDoListChangeEvent(this.change) : super(false);
}

class ListStreamConstructor
    extends StreamConstructor<List<ToDoItem>, ToDoList> {
  ListStreamConstructor(BlocPresenterBase bloc) : super(bloc);
  List<ToDoItem> itemList;

  @override
  Stream<List<ToDoItem>> _constructStream() {
    return bloc.streamEvents.where((event) => !event.isUserEvent).map((event) {
      if (event is ToDoListChangeEvent) {
        switch (event.change.event) {
          case to_do_list.Event.add_item:
            itemList.add(event.change.delta);
            break;
          case to_do_list.Event.change_item:
            int index = itemList.indexWhere((ToDoItem currentItem) {
              return currentItem.id == event.change.delta.id;
            });
            var res = itemList.elementAt(index);
            itemList.replaceRange(index, index + 1, [event.change.delta]);
            break;
          case to_do_list.Event.remove_all:
            itemList.clear();
            break;
          case to_do_list.Event.remove_item:
            itemList.removeWhere((ToDoItem currentItem) {
              bool val = (currentItem.id == event.change.delta.id);
              return val;
            });
            break;
          case to_do_list.Event.reset:
            bool done;
            if (bloc.filterStreamConstructor.current == Filter.done)
              done = true;
            else if (bloc.filterStreamConstructor.current == Filter.todo)
              done = false;
            bloc
                .execute(actions.GetToDoList(done: done))
                .then((actions.GetToDoList action) {
              bloc.events.add(ToDoListReseted(action.items));
            });
            break;
          default:
        }
      }
      if(event is ToDoListReseted){
        itemList = event.toDoList;
      }
      return itemList;
    });
  }
}

class FilterStreamConstructor extends StreamConstructor<Filter, ToDoList> {
  FilterStreamConstructor(BlocPresenterBase bloc) : super(bloc);
  Filter current;

  @override
  Stream<Filter> _constructStream() {
    return bloc.streamEvents
        .where((event) => event is ChangeFilter)
        .map((event) {
      if (current == Filter.all)
        current = Filter.done;
      else if (current == Filter.done)
        current = Filter.todo;
      else if (current == Filter.todo) current = Filter.all;
      if (current == Filter.done) return current;
    });
  }
}

enum Filter { all, done, todo }

class ToDoList extends BlocPresenterBase<ToDoListEvent> {
  ListStreamConstructor listStreamConstructor;
  FilterStreamConstructor filterStreamConstructor;
  @override
  void initiate(BuildContext context) {
    listStreamConstructor = ListStreamConstructor(this);
    filterStreamConstructor = FilterStreamConstructor(this);

    filterStreamConstructor.stream.listen((Filter filter) {
      bool done;
      if (filter == Filter.done)
        done = true;
      else if (filter == Filter.todo) done = false;
      execute(actions.GetToDoList(done: done))
          .then((actions.GetToDoList action) {
        events.add(ToDoListReseted(action.items));
      });
    });

    subscribeTo(notifications.ToDoListNotifier(),
        (NotificationBase notification) {
      notifications.ToDoListNotifier notificationRes =
          notification as notifications.ToDoListNotifier;
      to_do_list.LastChange change = notificationRes.data;
      events.add(ToDoListChangeEvent(change));
    });

    addUserInputHandler<RemoveItem>((event) {
      execute(actions.RemoveToDoItem(event.id));
    });

    addUserInputHandler<ChangeStatusItem>((event) {
      execute(actions.EditToDoItem(event.id, done: event.done));
    });

    addUserInputHandler<ShowCreateItem>((event) {
      Navigator.of(context).pushNamed('/Main/ToDoList/ToDoCreate');
    });

    addUserInputHandler<DeleateAll>((event) {
      execute(actions.RemoveAllToDoItem());
    });

    addUserInputHandler<ShowEditItem>((event) {
      Navigator.of(context)
          .pushNamed('/Main/ToDoList/ToDoEdit', arguments: event.id);
    });

    execute(actions.GetToDoList()).then((actions.GetToDoList action) {
      events.add(ToDoListReseted(action.items));
    });

    //     removeItem = Input.of(this, handler: (data) {
    //   execute(actions.RemoveToDoItem(data)).whenComplete(() {
    //     print('RemoveToDoItem compleated');
    //   });
    // });
    // changeStatusItem = Input.of(this, handler: (data) {
    //   execute(actions.EditToDoItem(data.id, done: data.done)).whenComplete(() {
    //     bool done;
    //     if (filter.value == Filter.done)
    //       done = true;
    //     else if (filter.value == Filter.todo) done = false;
    //     execute(actions.GetToDoList(done: done))
    //         .then((actions.GetToDoList action) {
    //       list.value = action.items;
    //     });
    //   });
    // });
    // showEditItem = Input.of(this, handler: (data) {
    //   Navigator.of(context)
    //       .pushNamed('/Main/ToDoList/ToDoEdit', arguments: data);
    // });
    // showCreateItem = Input.of(this, handler: (data) {
    //   Navigator.of(context).pushNamed('/Main/ToDoList/ToDoCreate');
    // });

    // deleateAll = Input.of(this, handler: (data) {
    //   execute(actions.RemoveAllToDoItem()).whenComplete(() {
    //     print('RemoveToDoItem compleated');
    //   });
    // });
  }
}
