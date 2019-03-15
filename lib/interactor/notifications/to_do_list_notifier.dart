import 'notification_base.dart';
import '../entities/entity_base.dart';
import '../entities/to_do_list.dart';
import '../data_stores/database/repositories/to_do_item.dart';

class ToDoListNotifier extends NotificationBase {
  final bool done;
  ToDoListNotifier({this.done});
  bool whenNotify(EntityBase entity) {
    return entity is IToDoList;
  }

  void grabData(EntityBase entity) {
    if (!(entity is IToDoList)) return;
    IToDoList toDoList = entity;
    if (done == null) {
      data = toDoList.toDoList;
    } else {
      List<ToDoItem> filteredList = [];

      for (ToDoItem item in toDoList.toDoList) {
        if (item.done = done) {
          filteredList.add(item);
        }
      }
      data = filteredList;
    }
  }
}
