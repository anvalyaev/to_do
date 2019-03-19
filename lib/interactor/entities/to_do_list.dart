import 'dart:async';
import 'entity_base.dart';
import '../data_stores/database/database.dart';
import '../data_stores/database/repositories/to_do_item.dart';

enum Event { add_item, change_item, remove_item, remove_all, reload }

class LastChange {
  LastChange({this.event, this.item});
  final Event event;
  final ToDoItem item;
}

abstract class IToDoList extends EntityBase {
  IToDoList(StreamController<EntityBase> controller) : super(controller);
  List<ToDoItem> get toDoList;
  LastChange get lastChange;
void reset({List<ToDoItem> items});
  ToDoItem addItem({String title, String description, int color, bool done});
  ToDoItem changeItem(String id,
      {String title, String description, int color, bool done});
  ToDoItem removeItem(String id);
  void removeAll();
}

class ToDoList extends IToDoList {
  List<ToDoItem> _toDoList = [];
  SembastDataBase _database;
  LastChange _lastChange;

  ToDoList(StreamController<EntityBase> controller)
      : super(controller);

  void reset({List<ToDoItem> items}) {
    _toDoList.clear();
    if (items != null) _toDoList = items;
    modelChanged();
  }

  // @override
  // void reload() {
  //   SembastToDoItemRepository repo = new SembastToDoItemRepository(_database);
  //   repo.getAll().then((List<ToDoItem> list) {
  //     _toDoList = list;
  //     modelChanged();
  //   });
  // }

  List<ToDoItem> get toDoList => _toDoList;
  LastChange get lastChange => _lastChange;

  ToDoItem addItem({String title, String description, int color, bool done}) {
    ToDoItem res = new ToDoItem();
    if (title != null) res.title = title;
    if (description != null) res.description = description;
    if (color != null) res.color = color;
    if (done != null) res.done = done;
    toDoList.add(res);
    modelChanged();
    return res;
  }

  ToDoItem changeItem(String id,
      {String title, String description, int color, bool done}) {
    ToDoItem res;
    int index = toDoList.indexWhere((ToDoItem currentItem) {
      return currentItem.id == id;
    });
    res = _toDoList.elementAt(index);

    if (title != null) res.title = title;
    if (description != null) res.description = description;
    if (color != null) res.color = color;
    if (done != null) res.done = done;

    toDoList.replaceRange(index, index + 1, [res]);
    modelChanged();
    return res;
  }

  ToDoItem removeItem(String id) {
    ToDoItem res;
    toDoList.removeWhere((ToDoItem currentItem) {
      bool val = (currentItem.id == id);
      if (val) res = currentItem;
      return val;
    });
    modelChanged();
    return res;
  }

  void removeAll() {
    toDoList.clear();
    modelChanged();
  }
}
