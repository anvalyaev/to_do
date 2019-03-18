import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';

class ToDoItem {
  String id = "todoitem_${Uuid().v4()}";
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
    var oldToDoItem = await _database.db.get(item.id) as Map;
    if (oldToDoItem == null) {
      await _database.db.put(newToDoItem, item.id);
    }
  }

  Future remove(ToDoItem item) async {
    bool contains = await _database.db.containsKey(item.id);
    if (contains) {
      await _database.db.delete(item.id);
    }
  }

  Future edit(ToDoItem item) async {
    Map toDoItem = {
      idKey: item.id,
      titleKey: item.title,
      descriptionKey: item.description,
      colorKey: item.color,
      doneKey: item.done
    };

    var oldToDoItem = await _database.db.get(item.id) as Map;
    if (oldToDoItem == null) {
      await _database.db.put(toDoItem, item.id);
    } else {
      await _database.db.update(toDoItem, item.id);
    }
  }

  Future<List<ToDoItem>> getAll() async {
    List<ToDoItem> res = [];
    var allKeys = await _database.db.findKeys(Finder(filter: Filter.matches("todoitem_", '')));
    print("all keys: $allKeys");
    if (allKeys == null) return res;

    for (dynamic key in allKeys) {
      Map toDoItemMap = await _database.db.get(key as String) as Map;
      ToDoItem toDoItem = new ToDoItem();
      toDoItem.id = toDoItemMap[idKey];
      toDoItem.title = toDoItemMap[titleKey];
      toDoItem.description = toDoItemMap[descriptionKey];
      toDoItem.color = toDoItemMap[colorKey];
      toDoItem.done = toDoItemMap[doneKey];
      res.add(toDoItem);
    }
    return res;
  }

  Future removeAll() async {
    List<ToDoItem> res = [];
    var allKeys = await _database.db.findKeys(Finder(filter: Filter.matches("todoitem_", '')));

    if (allKeys == null) return res;
    await _database.db.clear();
    return res;
  }
}
