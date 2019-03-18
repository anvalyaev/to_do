import 'dart:async';
import 'entity_base.dart';
import '../data_stores/database/database.dart';
import '../data_stores/database/repositories/to_do_item.dart';

abstract class IToDoList extends EntityBase {
  IToDoList(StreamController<EntityBase> controller) : super(controller);
  List<ToDoItem> get toDoList;
  ToDoItem addItem({String title, String description, int color, bool done});
  ToDoItem changeItem(String id,
      {String title, String description, int color, bool done});
  ToDoItem removeItem(String id);
  void removeAll();
}

class ToDoList extends IToDoList {
  List<ToDoItem> _toDoList = [];
  SembastDataBase _database;

  ToDoList(StreamController<EntityBase> controller, this._database)
      : super(controller);
  @override
  void initialize() {
    _toDoList = [];
    reload();
  }

  @override
  void reload() {
    SembastToDoItemRepository repo = new SembastToDoItemRepository(_database);
    repo.getAll().then((List<ToDoItem> list) {
      _toDoList = list;
      modelChanged();
    });
  }

  List<ToDoItem> get toDoList => _toDoList;

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
      if(val) res = currentItem;
      return val;
    });
    modelChanged();
    return res;
  }

  void removeAll(){
    toDoList.clear();
    modelChanged();
  }
}
