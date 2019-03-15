import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';


class ToDoItem {
  String id = Uuid().v4();
  String title = "";
  String description = "";
  int color = 0xFFFFFFFF;
  bool done = false;
}

abstract class ToDoItemRepository {
  Future add(ToDoItem item);
  Future remove(ToDoItem item);
  Future edit(ToDoItem item);
  Future<List<ToDoItem>> getAll();
}

final String toDoItemsKey = 'to_do_items';
final String idKey = 'id_to_do';
final String titleKey = 'title';
final String descriptionKey = 'description';
final String colorKey = 'color';
final String doneKey = 'done';

class SembastToDoItemRepository implements ToDoItemRepository {
  SembastDataBase _database;

  SembastToDoItemRepository(this._database);

  Future add(ToDoItem item) async {
    Map newToDoItem = {
      idKey: item.id,
      titleKey: item.title,
      descriptionKey: item.description,
      colorKey: item.color,
      doneKey: item.done
    };
    var oldToDoItemList = await _database.db.get(toDoItemsKey) as List<Map>;
    var newListToDoItem;
    if (oldToDoItemList == null) {
      newListToDoItem = [newToDoItem];
      _database.db.put(newListToDoItem, toDoItemsKey);
    } else {
      newListToDoItem = oldToDoItemList;
      newListToDoItem.add(newToDoItem);
      _database.db.update(newListToDoItem, toDoItemsKey);
    }
  }

  Future remove(ToDoItem item) async {
    Map toDoItem = {
      idKey: item.id,
      titleKey: item.title,
      descriptionKey: item.description,
      colorKey: item.color,
      doneKey: item.done
    };

    var oldToDoItem = await _database.db
        .findKey(Finder(filter: Filter.equal(idKey, item.id)));
  }

  Future edit(ToDoItem item) async {
    Map toDoItem = {
      idKey: item.id,
      titleKey: item.title,
      descriptionKey: item.description,
      colorKey: item.color,
      doneKey: item.done
    };

    var oldToDoItem = await _database.db
        .findKey(Finder(filter: Filter.equal(idKey, item.id)));
  }

  Future<List<ToDoItem>> getAll() async {
    List<ToDoItem> res = [];
    var oldToDoItemList = await _database.db.get(toDoItemsKey) as List<Map>;

    oldToDoItemList.forEach((Map toDoItemMap) {
      ToDoItem toDoItem = new ToDoItem();
      toDoItem.id = toDoItemMap[idKey];
      toDoItem.title = toDoItemMap[titleKey];
      toDoItem.description = toDoItemMap[descriptionKey];
      toDoItem.color = toDoItemMap[colorKey];
      toDoItem.done = toDoItemMap[doneKey];
      res.add(toDoItem);
    });
    return res;
  }
}
