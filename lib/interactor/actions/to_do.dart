import 'action_base.dart';
import '../accessor.dart';
import '../data_stores/database/repositories/to_do_item.dart';

class AddToDoItem extends ActionBase {
  final String title;
  final String description;
  final int color;
  final bool done;

  AddToDoItem({this.title, this.description, this.color, this.done});

  @override
  void doAction(Accessor accessor, void onCompleate(ActionBase result)) {
    IDatabase storage = accessor.database;
    IToDoList toDoList = accessor.toDoList;

    ToDoItem item = toDoList.addItem(
        title: title, description: description, color: color, done: done);
    var repo = SembastToDoItemRepository(storage);
    repo.add(item);
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
  void doAction(Accessor accessor, void onCompleate(ActionBase result)) {
    IDatabase storage = accessor.database;
    IToDoList toDoList = accessor.toDoList;
    ToDoItem item = toDoList.changeItem(itemId,
        title: title, description: description, color: color, done: done);
    var repo = SembastToDoItemRepository(storage);
    repo.edit(item);
    onCompleate(this);
  }
}

class RemoveToDoItem extends ActionBase {
  final String itemId;
  RemoveToDoItem(this.itemId);

  @override
  void doAction(Accessor accessor, void onCompleate(ActionBase result)) {
    IDatabase storage = accessor.database;
    IToDoList toDoList = accessor.toDoList;
    ToDoItem item = toDoList.removeItem(itemId);
    var repo = SembastToDoItemRepository(storage);
    repo.remove(item);
    onCompleate(this);
  }
}

class GetToDoItem extends ActionBase {
  ToDoItem item;
  final String itemId;

  GetToDoItem(this.itemId);
  @override
  void doAction(Accessor accessor, void onCompleate(ActionBase result)) {
    IToDoList toDoList = accessor.toDoList;
    item = toDoList.toDoList.firstWhere((ToDoItem currentItem){
      return currentItem.id == itemId;
    });
    onCompleate(this);
  }
}
