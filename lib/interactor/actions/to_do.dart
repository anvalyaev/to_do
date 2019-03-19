import 'action_base.dart';
import '../accessor.dart';
import '../data_stores/database/repositories/to_do_item.dart';

class AddToDoItem extends ActionBase {
  final String title;
  final String description;
  final int color;
  final bool done;
  final int count;

  AddToDoItem(
      {this.title, this.description, this.color, this.done = false, this.count = 1});

  @override
  void doAction(IAccessor accessor, void onCompleate(ActionBase result)) async {
    IDatabase storage = accessor.database;
    IToDoList toDoList = accessor.toDoList;

    for (int i = 0; i < count; ++i) {
      ToDoItem item = toDoList.addItem(
          title: title, description: description, color: color, done: done);
      var repo = SembastToDoItemRepository(storage);
      await repo.add(item);
    }

    onCompleate(this);
  }
}

class EditToDoItem extends ActionBase {
  final String itemId;
  final String title;
  final String description;
  final int color;
  final bool done;

  EditToDoItem(this.itemId,
      {this.title, this.description, this.color, this.done});

  @override
  void doAction(IAccessor accessor, void onCompleate(ActionBase result)) async {
    IDatabase storage = accessor.database;
    IToDoList toDoList = accessor.toDoList;
    ToDoItem item = toDoList.changeItem(itemId,
        title: title, description: description, color: color, done: done);
    var repo = SembastToDoItemRepository(storage);
    await repo.edit(item);
    // for (int i = 0; i < 100000; ++i) {
    //   print("$runtimeType : $i");
    // }
    onCompleate(this);
  }
}

class RemoveToDoItem extends ActionBase {
  final String itemId;
  RemoveToDoItem(this.itemId);

  @override
  void doAction(IAccessor accessor, void onCompleate(ActionBase result)) async {
    IDatabase storage = accessor.database;
    IToDoList toDoList = accessor.toDoList;
    ToDoItem item = toDoList.removeItem(itemId);
    var repo = SembastToDoItemRepository(storage);
    await repo.remove(item);
    onCompleate(this);
  }
}

class RemoveAllToDoItem extends ActionBase {
  RemoveAllToDoItem();

  @override
  void doAction(IAccessor accessor, void onCompleate(ActionBase result)) async {
    IDatabase storage = accessor.database;
    IToDoList toDoList = accessor.toDoList;
    toDoList.removeAll();
    var repo = SembastToDoItemRepository(storage);
    await repo.removeAll();
    onCompleate(this);
  }
}

class GetToDoItem extends ActionBase {
  ToDoItem item;
  final String itemId;

  GetToDoItem(this.itemId);
  @override
  void doAction(IAccessor accessor, void onCompleate(ActionBase result)) {
    IToDoList toDoList = accessor.toDoList;
    item = toDoList.toDoList.firstWhere((ToDoItem currentItem) {
      return currentItem.id == itemId;
    });
    onCompleate(this);
  }
}

class GetToDoList extends ActionBase {
  final bool done;
  List<ToDoItem> items = [];

  GetToDoList({this.done});
  @override
  void doAction(IAccessor accessor, void onCompleate(ActionBase result)) {
    if(done == null){
    IToDoList toDoList = accessor.toDoList;
    items = toDoList.toDoList;
    onCompleate(this);
    return;
    } else {
      for(ToDoItem item in accessor.toDoList.toDoList){
        if(item.done == done){
          items.add(item);
        }
      }
      onCompleate(this);
      return;
    }
  }
}
